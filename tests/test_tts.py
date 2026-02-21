#!/usr/bin/env python3
"""Test script for MiniMax TTS integration."""

import requests
import base64
import os

BACKEND_URL = "http://localhost:8000"

def test_tts_endpoint():
    """Test the /tts/speak endpoint."""
    print("🎤 Testing MiniMax TTS endpoint...")
    
    response = requests.post(
        f"{BACKEND_URL}/tts/speak",
        json={
            "text": "Security alert: Unauthorized access detected in patient records.",
            "voice_id": "English_Trustworth_Man"
        }
    )
    
    if response.status_code == 200:
        data = response.json()
        if data.get("success"):
            audio_size = len(base64.b64decode(data["audio_base64"]))
            print(f"✅ TTS Success! Audio size: {audio_size} bytes")
            print(f"   Text: {data['text'][:50]}...")
            print(f"   Voice: {data['voice_id']}")
            
            # Optionally save to file
            with open("/tmp/test_tts.mp3", "wb") as f:
                f.write(base64.b64decode(data["audio_base64"]))
            print(f"   Saved to: /tmp/test_tts.mp3")
            
            return True
        else:
            print(f"❌ TTS Failed: {data.get('error')}")
            return False
    else:
        print(f"❌ HTTP Error: {response.status_code}")
        print(f"   Response: {response.text}")
        return False

def test_daily_summary():
    """Test the daily security summary endpoint."""
    print("\n📊 Testing Daily Security Summary...")
    
    response = requests.post(f"{BACKEND_URL}/security/daily-summary")
    
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Summary Generated!")
        print(f"   Total Requests: {data['summary']['total_requests']}")
        print(f"   Blocked: {data['summary']['blocked_requests']}")
        print(f"   VIP Accesses: {data['summary']['vip_accesses']}")
        print(f"   Compliance: {data['summary']['compliance_score']}%")
        print(f"   TTS Triggered: {data['tts_triggered']}")
        return True
    else:
        print(f"❌ HTTP Error: {response.status_code}")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("MiniMax TTS Integration Test")
    print("=" * 60)
    
    # Check if API key is configured
    if not os.getenv("MINIMAX_API_KEY"):
        print("⚠️  Warning: MINIMAX_API_KEY not found in environment")
    
    # Run tests
    tts_ok = test_tts_endpoint()
    summary_ok = test_daily_summary()
    
    print("\n" + "=" * 60)
    if tts_ok and summary_ok:
        print("✅ All tests passed!")
    else:
        print("❌ Some tests failed")
    print("=" * 60)
