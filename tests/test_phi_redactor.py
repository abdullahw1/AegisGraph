"""Unit tests for PHI Redactor."""

import pytest
from backend.tools.phi_redactor import PHIRedactor


def test_ssn_redaction():
    """Test SSN redaction shows only last 4 digits."""
    redactor = PHIRedactor()
    
    text = "Patient SSN is 123-45-6789"
    redacted, count = redactor.redact(text)
    
    assert "***-**-6789" in redacted
    assert "123-45-6789" not in redacted
    assert count == 1


def test_ssn_no_dash_redaction():
    """Test SSN without dashes is redacted."""
    redactor = PHIRedactor()
    
    text = "Patient SSN is 123456789"
    redacted, count = redactor.redact(text)
    
    assert "*****6789" in redacted
    assert "123456789" not in redacted
    assert count == 1


def test_credit_card_redaction():
    """Test credit card redaction shows only last 4 digits."""
    redactor = PHIRedactor()
    
    text = "Card number: 1234-5678-9012-3456"
    redacted, count = redactor.redact(text)
    
    assert "****-****-****-3456" in redacted
    assert "1234-5678-9012-3456" not in redacted
    assert count == 1


def test_phone_redaction():
    """Test phone number redaction shows only last 4 digits."""
    redactor = PHIRedactor()
    
    text = "Call me at 555-123-4567"
    redacted, count = redactor.redact(text)
    
    assert "***-***-4567" in redacted
    assert "555-123-4567" not in redacted
    assert count == 1


def test_phone_allowed_with_context():
    """Test patient's own phone is not redacted."""
    redactor = PHIRedactor()
    
    text = "Patient phone: 555-123-4567"
    patient_context = {
        'patient': {
            'phone': '555-123-4567'
        }
    }
    
    redacted, count = redactor.redact(text, patient_context)
    
    assert "555-123-4567" in redacted  # Not redacted
    assert count == 0


def test_email_redaction():
    """Test email redaction keeps domain."""
    redactor = PHIRedactor()
    
    text = "Email: doctor@hospital.com"
    redacted, count = redactor.redact(text)
    
    assert "[REDACTED]@hospital.com" in redacted
    assert "doctor@hospital.com" not in redacted
    assert count == 1


def test_email_allowed_with_context():
    """Test patient's own email is not redacted."""
    redactor = PHIRedactor()
    
    text = "Patient email: patient@email.com"
    patient_context = {
        'patient': {
            'email': 'patient@email.com'
        }
    }
    
    redacted, count = redactor.redact(text, patient_context)
    
    assert "patient@email.com" in redacted  # Not redacted
    assert count == 0


def test_address_redaction():
    """Test street address redaction."""
    redactor = PHIRedactor()
    
    text = "Lives at 123 Oak Street, San Francisco"
    redacted, count = redactor.redact(text)
    
    assert "[REDACTED ADDRESS]" in redacted
    assert "123 Oak Street" not in redacted
    assert count == 1


def test_zip_plus4_redaction():
    """Test ZIP+4 redaction keeps 5-digit ZIP."""
    redactor = PHIRedactor()
    
    text = "ZIP code: 94102-1234"
    redacted, count = redactor.redact(text)
    
    assert "94102-****" in redacted
    assert "94102-1234" not in redacted
    assert count == 1


def test_multiple_redactions():
    """Test multiple PHI items are all redacted."""
    redactor = PHIRedactor()
    
    text = """
    Patient Info:
    SSN: 123-45-6789
    Phone: 555-123-4567
    Email: patient@email.com
    Address: 456 Pine Avenue
    """
    
    redacted, count = redactor.redact(text)
    
    assert "***-**-6789" in redacted
    assert "***-***-4567" in redacted
    assert "[REDACTED]@email.com" in redacted
    assert "[REDACTED ADDRESS]" in redacted
    assert count == 4


def test_no_redaction_needed():
    """Test text with no PHI returns unchanged."""
    redactor = PHIRedactor()
    
    text = "Patient has diabetes and takes metformin."
    redacted, count = redactor.redact(text)
    
    assert redacted == text
    assert count == 0


def test_empty_text():
    """Test empty text returns empty."""
    redactor = PHIRedactor()
    
    redacted, count = redactor.redact("")
    
    assert redacted == ""
    assert count == 0


def test_none_text():
    """Test None text returns None."""
    redactor = PHIRedactor()
    
    redacted, count = redactor.redact(None)
    
    assert redacted is None
    assert count == 0


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
