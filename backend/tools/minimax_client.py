import logging
import os
import json
import base64
from typing import Optional, Dict

import requests
import ddtrace

logger = logging.getLogger(__name__)


class MiniMaxClient:
    """TTS client using MiniMax API for voice alerts and response playback."""

    def __init__(self):
        self.api_key = os.getenv("MINIMAX_API_KEY")
        self.api_url = "https://api.minimax.io/v1/t2a_v2"
        
        if not self.api_key:
            logger.warning("MINIMAX_API_KEY not found — TTS disabled.")
            self._enabled = False
        else:
            logger.info("MiniMaxClient: TTS enabled with API key.")
            self._enabled = True

    def text_to_speech(self, text: str, voice_id: str = "English_Trustworth_Man") -> Dict:
        """
        Convert text to speech using MiniMax API.
        
        Args:
            text: The text to convert to speech
            voice_id: Voice ID to use (default: English_Trustworth_Man)
            
        Returns:
            dict with audio_base64 and metadata
        """
        with ddtrace.tracer.trace("minimax.text_to_speech") as span:
            span.set_tag("text_length", len(text))
            span.set_tag("voice_id", voice_id)
            
            if not self._enabled:
                logger.warning("TTS disabled - no API key")
                return {"success": False, "error": "No API key configured"}
            
            try:
                headers = {
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json"
                }
                
                payload = {
                    "model": "speech-2.8-hd",
                    "text": text,
                    "stream": False,
                    "voice_setting": {
                        "voice_id": voice_id,
                        "speed": 1.0,
                        "vol": 1.0,
                        "pitch": 0
                    },
                    "audio_setting": {
                        "sample_rate": 32000,
                        "bitrate": 128000,
                        "format": "mp3",
                        "channel": 1
                    },
                    "output_format": "hex"
                }
                
                response = requests.post(self.api_url, headers=headers, json=payload, timeout=30)
                
                if response.status_code == 200:
                    data = response.json()
                    
                    # Convert hex to base64 for browser playback
                    if "data" in data and "audio" in data["data"]:
                        hex_audio = data["data"]["audio"]
                        audio_bytes = bytes.fromhex(hex_audio)
                        audio_base64 = base64.b64encode(audio_bytes).decode('utf-8')
                        
                        logger.info(f"TTS generated successfully ({len(audio_bytes)} bytes)")
                        span.set_tag("audio_size", len(audio_bytes))
                        
                        return {
                            "success": True,
                            "audio_base64": audio_base64,
                            "text": text,
                            "voice_id": voice_id
                        }
                    else:
                        logger.error(f"Unexpected response format: {data}")
                        return {"success": False, "error": "Unexpected response format"}
                else:
                    logger.error(f"MiniMax API error: {response.status_code} - {response.text}")
                    return {"success": False, "error": f"API error: {response.status_code}"}
                    
            except Exception as e:
                logger.error(f"Error generating TTS: {e}", exc_info=True)
                span.set_tag("error", str(e))
                return {"success": False, "error": str(e)}

    def speak_alert(self, text: str, request_id: Optional[str] = None, 
                   security_mode: Optional[str] = None,
                   doc_id: Optional[str] = None,
                   patient_id: Optional[str] = None) -> None:
        """Speak an incident alert via MiniMax TTS."""
        with ddtrace.tracer.trace("minimax.tts_alert") as span:
            # Add span tags
            if request_id:
                span.set_tag("request_id", request_id)
            if security_mode:
                span.set_tag("security_mode", security_mode)
            if doc_id:
                span.set_tag("doc_id", doc_id)
            if patient_id:
                span.set_tag("patient_id", patient_id)
            span.set_tag("alert_text", text[:200])
            
            if not self._enabled:
                logger.debug("TTS skipped (no API key).")
                return
            
            try:
                result = self.text_to_speech(text)
                if result.get("success"):
                    logger.info(f"TTS alert sent - {text[:100]}")
                else:
                    logger.warning(f"TTS alert failed: {result.get('error')}")
            except Exception as exc:
                logger.warning("TTS call failed: %s", exc)
                # Do not re-raise — pipeline must not fail due to TTS errors

