"""PHI Redactor - Automatically redacts sensitive PHI from text responses."""

import re
import logging
from typing import Tuple

logger = logging.getLogger(__name__)


class PHIRedactor:
    """Redacts sensitive PHI patterns from text to prevent accidental data leaks."""
    
    # Regex patterns for sensitive data
    SSN_PATTERN = re.compile(r'\b\d{3}-\d{2}-\d{4}\b')
    SSN_NO_DASH_PATTERN = re.compile(r'\b\d{9}\b')
    CREDIT_CARD_PATTERN = re.compile(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b')
    PHONE_PATTERN = re.compile(r'\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b')
    EMAIL_PATTERN = re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
    ZIP_PLUS4_PATTERN = re.compile(r'\b\d{5}-\d{4}\b')
    
    # Address patterns (common street indicators)
    ADDRESS_INDICATORS = [
        r'\b\d+\s+[A-Z][a-z]+\s+(Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Court|Ct|Way|Place|Pl)\b',
        r'\b\d+\s+[A-Z][a-z]+\s+[A-Z][a-z]+\s+(Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Court|Ct|Way|Place|Pl)\b'
    ]
    
    def __init__(self):
        """Initialize the PHI redactor."""
        self.redaction_count = 0
    
    def redact(self, text: str, patient_context: dict = None) -> Tuple[str, int]:
        """
        Redact sensitive PHI from text.
        
        Args:
            text: The text to redact
            patient_context: Optional patient context to allow certain data
            
        Returns:
            Tuple of (redacted_text, redaction_count)
        """
        if not text:
            return text, 0
        
        self.redaction_count = 0
        redacted_text = text
        
        # Get allowed data from patient context (data that's OK to show)
        allowed_phone = None
        allowed_email = None
        if patient_context:
            patient = patient_context.get('patient', {})
            allowed_phone = patient.get('phone')
            allowed_email = patient.get('email')
        
        # 1. Redact SSNs (show last 4 digits only)
        redacted_text = self._redact_ssn(redacted_text)
        
        # 2. Redact credit card numbers (show last 4 digits only)
        redacted_text = self._redact_credit_cards(redacted_text)
        
        # 3. Redact phone numbers (except patient's own)
        redacted_text = self._redact_phones(redacted_text, allowed_phone)
        
        # 4. Redact email addresses (except patient's own)
        redacted_text = self._redact_emails(redacted_text, allowed_email)
        
        # 5. Redact full addresses
        redacted_text = self._redact_addresses(redacted_text)
        
        # 6. Redact ZIP+4 codes (keep 5-digit ZIP)
        redacted_text = self._redact_zip_plus4(redacted_text)
        
        logger.info(f"PHI Redaction: {self.redaction_count} items redacted")
        
        return redacted_text, self.redaction_count
    
    def _redact_ssn(self, text: str) -> str:
        """Redact SSNs, showing only last 4 digits."""
        def replace_ssn(match):
            self.redaction_count += 1
            ssn = match.group(0)
            # Show last 4 digits: XXX-XX-1234
            if '-' in ssn:
                return f"***-**-{ssn[-4:]}"
            else:
                return f"*****{ssn[-4:]}"
        
        text = self.SSN_PATTERN.sub(replace_ssn, text)
        text = self.SSN_NO_DASH_PATTERN.sub(replace_ssn, text)
        return text
    
    def _redact_credit_cards(self, text: str) -> str:
        """Redact credit card numbers, showing only last 4 digits."""
        def replace_cc(match):
            self.redaction_count += 1
            cc = match.group(0)
            # Show last 4 digits: ****-****-****-1234
            last_four = re.sub(r'[-\s]', '', cc)[-4:]
            return f"****-****-****-{last_four}"
        
        return self.CREDIT_CARD_PATTERN.sub(replace_cc, text)
    
    def _redact_phones(self, text: str, allowed_phone: str = None) -> str:
        """Redact phone numbers, showing only last 4 digits (unless it's the patient's own)."""
        def replace_phone(match):
            phone = match.group(0)
            # Don't redact if it's the patient's own phone
            if allowed_phone and re.sub(r'[-.\s]', '', phone) == re.sub(r'[-.\s]', '', allowed_phone):
                return phone
            
            self.redaction_count += 1
            # Show last 4 digits: ***-***-1234
            digits = re.sub(r'[-.\s]', '', phone)
            return f"***-***-{digits[-4:]}"
        
        return self.PHONE_PATTERN.sub(replace_phone, text)
    
    def _redact_emails(self, text: str, allowed_email: str = None) -> str:
        """Redact email addresses (unless it's the patient's own)."""
        def replace_email(match):
            email = match.group(0)
            # Don't redact if it's the patient's own email
            if allowed_email and email.lower() == allowed_email.lower():
                return email
            
            self.redaction_count += 1
            # Redact username, keep domain: [REDACTED]@example.com
            domain = email.split('@')[1] if '@' in email else 'domain.com'
            return f"[REDACTED]@{domain}"
        
        return self.EMAIL_PATTERN.sub(replace_email, text)
    
    def _redact_addresses(self, text: str) -> str:
        """Redact street addresses."""
        for pattern in self.ADDRESS_INDICATORS:
            def replace_address(match):
                self.redaction_count += 1
                return "[REDACTED ADDRESS]"
            
            text = re.sub(pattern, replace_address, text, flags=re.IGNORECASE)
        
        return text
    
    def _redact_zip_plus4(self, text: str) -> str:
        """Redact ZIP+4 codes, keeping only 5-digit ZIP."""
        def replace_zip(match):
            self.redaction_count += 1
            zip_code = match.group(0)
            # Keep first 5 digits: 94102-****
            return f"{zip_code[:5]}-****"
        
        return self.ZIP_PLUS4_PATTERN.sub(replace_zip, text)
    
    def get_redaction_summary(self) -> dict:
        """Get summary of redactions performed."""
        return {
            "total_redactions": self.redaction_count,
            "redaction_enabled": True
        }
