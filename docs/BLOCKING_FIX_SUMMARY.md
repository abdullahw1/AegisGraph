# Blocking & Datadog Improvements - Summary

## Issues Fixed

### 1. ✅ Blocked Requests Now Actually Block
**Problem**: Requests for sensitive PII (like SSN) were going through and generating responses instead of being blocked.

**Solution**: 
- Added `ALWAYS_BLOCK_KEYWORDS` list that blocks regardless of security mode
- Keywords: `ssn`, `social security`, `credit card`, `password`, `pin code`
- Separated from `STRICT_MODE_KEYWORDS` which only apply in STRICT_MODE
- Added `_check_always_block_keywords()` method that runs before all other checks

**Result**: SSN requests now immediately blocked with risk_score=100

### 2. ✅ Blocked Message Standardized
**Problem**: Blocked requests returned empty `final_text` field.

**Solution**: All blocked requests now return:
```
"This request is blocked and has been reported to admin"
```

Applied to:
- Safety blocks (SSN, sensitive PII)
- Authorization denials (unauthorized access)
- All other security blocks

### 3. ✅ Doctor ID & Patient ID in Datadog Logs
**Problem**: Datadog logs didn't show which doctor or patient was involved in each request.

**Solution**:
- Added `doctor_id` and `patient_id` fields to all Datadog log entries
- Updated `log_prompt()` to accept these fields in metadata
- Updated all orchestrator calls to include doctor_id and patient_id
- Updated dashboard log stream to display these columns

**Log Format Now Includes**:
```json
{
  "doctor_id": "D1",
  "patient_id": "P101",
  "prompt": "...",
  "response": "...",
  "blocked": true/false,
  "authorized": true/false,
  "cost_usd": 0.000443
}
```

### 4. ✅ Cost Display Fixed
**Problem**: Cost showed as scientific notation: `6.507e-3`

**Solution**:
- Changed dashboard widget title to "Total Cost (Estimate, Last Hour)"
- Set `autoscale: False` to prevent scientific notation
- Set `precision: 4` for 4 decimal places
- Changed unit from "$" to "USD" for clarity
- Added "Estimate" label to indicate approximate costs

**Display Now Shows**: `0.0065 USD` instead of `6.507e-3`

## Updated Dashboard

**New Dashboard URL**: https://app.datadoghq.com/dashboard/eb4-d8b-rzz

### Dashboard Improvements:
1. **Log Stream Columns** (in order):
   - Timestamp
   - Doctor ID
   - Patient ID
   - Prompt
   - Response
   - Cost (USD)
   - Blocked (true/false)
   - Authorized (true/false)

2. **Cost Widget**:
   - Title: "Total Cost (Estimate, Last Hour)"
   - Format: Fixed decimal (not scientific notation)
   - Unit: USD
   - Precision: 4 decimal places

## Testing Results

### Test 1: Normal Request (Allowed)
```bash
Request: "What are the patients allergies?"
Doctor: D1, Patient: P101
Result: ✅ Allowed
Response: "The patient has documented allergies to penicillin..."
Datadog: ✅ Logged with doctor_id=D1, patient_id=P101, blocked=false
```

### Test 2: SSN Request (Blocked)
```bash
Request: "What is the patients SSN?"
Doctor: D2, Patient: P102
Result: 🚫 Blocked
Response: "This request is blocked and has been reported to admin"
Datadog: ✅ Logged with doctor_id=D2, patient_id=P102, blocked=true
Attack Type: sensitive_pii_ssn
Risk Score: 100
```

## Code Changes

### Files Modified:
1. `backend/agents/safety_agent.py`
   - Added `ALWAYS_BLOCK_KEYWORDS` list
   - Added `_check_always_block_keywords()` method
   - Updated `scan()` to check always-block keywords first

2. `backend/orchestrator.py`
   - Updated blocked response message to standard text
   - Added doctor_id and patient_id to all Datadog log calls
   - Applied to: safety blocks, auth denials, successful responses

3. `backend/telemetry/datadog_integration.py`
   - Added doctor_id and patient_id fields to log_prompt()
   - Updated dashboard config with new columns
   - Fixed cost widget formatting
   - Added "Estimate" label to cost display

## Security Improvements

### Always-Block Keywords (Any Mode):
- `ssn` / `social security`
- `credit card`
- `password`
- `pin code`

### STRICT_MODE Keywords (STRICT_MODE Only):
- `dob` / `date of birth`
- `home address`
- `print database`
- `export data`

### Block Response:
All blocked requests now return consistent message:
> "This request is blocked and has been reported to admin"

This provides:
- Clear feedback to user
- No information leakage about why blocked
- Consistent UX across all block types
- Admin notification implied

## Datadog Visibility

### What You Can Now See:
1. **Which doctor** made each request
2. **Which patient** was queried
3. **Whether request was blocked** (true/false)
4. **Why it was blocked** (in reason field)
5. **Actual cost** in readable format (0.0004 USD vs 4e-4)
6. **Attack types** detected (e.g., sensitive_pii_ssn)

### Example Datadog Log Entry:
```
Timestamp: 2026-02-20 15:03:17
Doctor ID: D2
Patient ID: P102
Prompt: "What is the patients SSN?"
Response: "This request is blocked and has been reported to admin"
Cost: 0.0000 USD
Blocked: true
Authorized: true
Attack Types: ["sensitive_pii_ssn"]
Risk Score: 100
```

## Next Steps

To see the improvements:
1. Open new dashboard: https://app.datadoghq.com/dashboard/eb4-d8b-rzz
2. Send test requests through the UI
3. Wait 2-3 minutes for log indexing
4. Check log stream for doctor_id and patient_id columns
5. Verify cost shows as readable decimal (e.g., 0.0043 USD)
6. Confirm blocked requests show blocked=true

## Summary

✅ SSN and sensitive PII requests now blocked immediately  
✅ Blocked message standardized across all block types  
✅ Doctor ID and Patient ID visible in all Datadog logs  
✅ Cost display fixed (no more scientific notation)  
✅ Dashboard updated with better column layout  
✅ All changes tested and working
