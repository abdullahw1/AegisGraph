# AegisGraph

**HIPAA-Aligned LLM Firewall with Graph-Based Authorization**

AegisGraph is a production-ready security-first LLM gateway that enforces HIPAA compliance through a four-agent pipeline with Neo4j-powered authorization, real-time threat detection, automatic PHI redaction, self-healing security escalation, and comprehensive Datadog observability.

## 🎯 Key Features

### 🔒 Four-Agent Security Pipeline
- **Intent Agent**: Classifies request intent (TREATMENT, DIAGNOSIS, ADMIN, EMERGENCY)
- **Graph Policy Agent**: Neo4j relationship validation for doctor-patient access control
- **Safety Agent**: Real-time threat detection (prompt injection, jailbreak, PII exfiltration)
- **Response Agent**: Context-aware clinical responses with automatic PHI redaction

### 🏥 Healthcare-Specific Features
- **HIPAA Compliance**: Complete audit trails, access controls, and PHI protection
- **Automatic PHI Redaction**: Real-time detection and redaction of sensitive information (SSN, credit cards, emails, phone numbers, addresses)
- **Break-Glass Emergency Access**: One-click emergency mode with full audit logging
- **VIP Patient Protection**: Enhanced monitoring for high-profile patients
- **Risk Scoring**: Real-time patient risk assessment based on access patterns

### 🛡️ Advanced Security
- **Self-Healing Security**: Automatic escalation to STRICT_MODE after threshold breaches
- **Attack Pattern Analytics**: Real-time categorization of threats (prompt injection, PHI exfiltration, keyword blocks)
- **Security Mode Management**: NORMAL → STRICT_MODE → LOCKDOWN with automatic reversion
- **Datadog MCP Integration**: Intelligent threat detection with configurable thresholds

### 📊 Comprehensive Observability
- **Datadog APM**: Full distributed tracing with ddtrace integration
- **LLM Observability**: All prompts, responses, and costs tracked
- **Custom Dashboards**: Pre-built dashboard with 10+ widgets
- **Real-Time Metrics**: Live security alerts, attack patterns, and compliance scores
- **Cost Tracking**: Token usage and LLM costs monitored per request

### 🎨 Modern Web Interface
- **Three-Panel Layout**: Patient list with risk badges, chat interface, live metrics dashboard
- **Emergency Mode UI**: Visual indicators and one-click emergency access
- **Live Security Alerts**: Real-time security event stream
- **Attack Pattern Visualization**: Bar charts showing threat distribution
- **HIPAA Compliance Score**: Live compliance percentage display
- **Text-to-Speech**: MiniMax TTS integration for voice alerts and response playback

### 🔊 Voice Features (NEW)
- **MiniMax TTS Integration**: Convert responses to speech with high-quality voices
- **Speak Response Button**: Click to hear any assistant response
- **Security Voice Alerts**: Automatic voice notifications for critical security events
- **Daily Security Summaries**: Automated voice reports of security metrics

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  (Doctor Login → Patient Selection → Chat + Voice)          │
│  • Risk Badges • Live Metrics • Attack Analytics            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Security Pipeline                         │
│                                                              │
│  1. LOCKDOWN Gate     → Immediate refusal if locked         │
│  2. Intent Agent      → Classify request intent             │
│  3. Graph Policy      → Neo4j authorization + emergency      │
│  4. Deny Gate         → Block unauthorized access           │
│  5. Safety Agent      → Threat detection & scanning         │
│  6. Block Gate        → Stop malicious requests + TTS alert │
│  7. Response Agent    → LLM generation + PHI redaction      │
│  8. Datadog Metrics   → Log everything                      │
│  9. Self-Heal Check   → Auto-escalate if threshold hit      │
│  10. Save History     → Neo4j audit trail                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Data & Monitoring                         │
│                                                              │
│  • Neo4j: Relationships, chat history, audit logs           │
│  • Datadog: APM traces, logs, metrics, dashboards           │
│  • AWS Bedrock: Claude 3.5 Sonnet for LLM inference         │
│  • MiniMax: Text-to-speech for voice alerts                 │
│  • PHI Redactor: Real-time sensitive data detection         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites
- Python 3.10+
- Neo4j Aura account (or local Neo4j instance)
- Datadog account (for monitoring)
- AWS Bedrock access (optional - mock mode available)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd AegisGraph
```

2. **Create virtual environment**
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your credentials:
# - NEO4J_URI, NEO4J_USERNAME, NEO4J_PASSWORD
# - DD_API_KEY, DD_APP_KEY (Datadog)
# - AWS credentials (optional if using mock mode)
```

5. **Seed Neo4j database**
```bash
python backend/seed_data/seed.py
```

6. **Start the backend**
```bash
./start_backend.sh
# Or manually: uvicorn backend.main:app --reload
```

7. **Access the UI**
```bash
open http://localhost:8000
```

### Default Credentials
- All doctor passcodes: `1234`
- Doctors: D1 (Cardiology), D2 (Neurology), D3 (Orthopedics)
- Patients: P101, P102, P103, P104, P105, P106

## Configuration

### Environment Variables

Create a `.env` file with the following:

```bash
# Neo4j Configuration
NEO4J_URI=neo4j+s://your-instance.databases.neo4j.io
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=your-password
NEO4J_DATABASE=neo4j

# Datadog Configuration
DD_API_KEY=your-datadog-api-key
DD_APP_KEY=your-datadog-app-key
DD_AGENT_HOST=localhost
DD_STATSD_PORT=8125
DD_DASHBOARD_URL=https://app.datadoghq.com/dashboard/your-dashboard-id

# AWS Bedrock Configuration
AWS_REGION=us-west-2
AWS_DEFAULT_REGION=us-west-2
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_SESSION_TOKEN=your-session-token  # Optional for temporary credentials

# MiniMax TTS (Optional - for voice features)
MINIMAX_API_KEY=your-minimax-api-key

# Mock Mode (set to false to use real AWS Bedrock)
USE_MOCK_BEDROCK=false
```

### Security Modes

AegisGraph supports three security modes:

1. **NORMAL**: Standard authorization checks
2. **STRICT_MODE**: Enhanced security (auto-triggered after threshold breaches)
3. **LOCKDOWN**: All requests blocked (emergency shutdown)

Change mode via API:
```bash
curl -X POST http://localhost:8000/mode \
  -H "Content-Type: application/json" \
  -d '{"mode": "NORMAL"}'
```

## API Endpoints

### Chat
```bash
POST /chat
{
  "user_id": "D1",
  "role": "Cardiologist",
  "doc_id": "D1",
  "patient_id": "P101",
  "message": "What is the patient's blood type?",
  "emergency_mode": false
}
```

### Text-to-Speech (NEW)
```bash
POST /tts/speak
{
  "text": "Security alert: Unauthorized access detected",
  "voice_id": "English_Trustworth_Man"
}
```

### Security & Monitoring
```bash
GET /metrics                          # Current system metrics
GET /mode                             # Current security mode
POST /mode                            # Change security mode
GET /security/alerts                  # Recent security alerts (last 20)
GET /security/attack-patterns         # Attack pattern analytics
POST /security/daily-summary          # Generate daily security summary with TTS
```

### Doctors & Patients
```bash
GET /doctors                          # List all doctors
GET /patients?doctor_id=D1            # List patients for doctor (with risk scores)
GET /chat/history?patient_id=P101&doctor_id=D1  # Get chat history
```

### Datadog Integration
```bash
POST /datadog/create-dashboard        # Create Datadog dashboard programmatically
```

### Activity Logging
```bash
POST /activity/log
{
  "doctor_id": "D1",
  "type": "EMERGENCY_ACCESS",
  "description": "Accessed all patients in emergency mode",
  "timestamp": "2024-02-20T12:00:00Z"
}
```

## Datadog Integration

### Create Dashboard
```bash
curl -X POST http://localhost:8000/datadog/create-dashboard
```

Returns:
```json
{
  "success": true,
  "dashboard_url": "https://app.datadoghq.com/dashboard/xxx-xxx-xxx",
  "message": "Dashboard created successfully"
}
```

### Dashboard Features
- **Total Requests**: Live count of all requests
- **Blocked Requests**: Security blocks and denials
- **Token Usage**: LLM input/output tokens over time
- **Cost Tracking**: Cumulative LLM costs
- **Log Stream**: Real-time prompts and responses
- **Security Metrics**: Authorization rates, PHI risk scores

### Viewing Logs
Logs appear in Datadog after 2-5 minutes of indexing:
- **Logs Explorer**: https://app.datadoghq.com/logs?query=source:aegisgraph
- **Dashboard**: Created via `/datadog/create-dashboard` endpoint

## Testing

### Run All Tests
```bash
# Run all tests
pytest tests/

# Run with coverage
pytest tests/ --cov=backend --cov-report=html

# Run specific test file
pytest tests/test_orchestrator.py

# Run with verbose output
pytest tests/ -v
```

### Individual Test Files
```bash
# Integration tests
pytest tests/test_integration.py

# Agent tests
pytest tests/test_intent_agent.py
pytest tests/test_graph_policy_agent.py
pytest tests/test_safety_agent.py
pytest tests/test_response_agent.py

# Feature tests
pytest tests/test_phi_redactor.py
pytest tests/test_tts.py

# Connectivity tests
python tests/test_connectivity.py
```

## Project Structure

```
AegisGraph/
├── backend/
│   ├── agents/              # Four-agent security pipeline
│   │   ├── intent_agent.py
│   │   ├── graph_policy_agent.py
│   │   ├── safety_agent.py
│   │   └── response_agent.py
│   ├── models/              # Pydantic schemas
│   │   └── schemas.py
│   ├── tools/               # External integrations
│   │   ├── neo4j_client.py
│   │   ├── bedrock_client.py
│   │   ├── mock_bedrock_client.py
│   │   ├── minimax_client.py      # TTS integration
│   │   ├── phi_redactor.py        # PHI detection & redaction
│   │   └── datadog_mcp_tool.py    # Self-healing security
│   ├── telemetry/           # Observability
│   │   ├── datadog_integration.py
│   │   ├── ddtrace_setup.py
│   │   └── metrics.py
│   ├── seed_data/           # Database seeding
│   │   ├── seed.py
│   │   └── seed.cypher
│   ├── orchestrator.py      # Pipeline coordinator
│   └── main.py              # FastAPI application
├── ui/
│   ├── app.html             # Modern web interface
│   └── index.html           # Landing page
├── tests/                   # All test files
│   ├── test_orchestrator.py
│   ├── test_integration.py
│   ├── test_main.py
│   ├── test_intent_agent.py
│   ├── test_graph_policy_agent.py
│   ├── test_safety_agent.py
│   ├── test_response_agent.py
│   ├── test_phi_redactor.py
│   ├── test_tts.py
│   └── test_connectivity.py
├── .env.example             # Environment template
├── .env                     # Your configuration (gitignored)
├── requirements.txt         # Python dependencies
├── start_backend.sh         # Backend startup script
├── start_ui.sh              # UI startup script
└── README.md                # This file
```

## Documentation

- **[QUICK_START.md](QUICK_START.md)**: Step-by-step setup guide
- **[DEMO_GUIDE.md](DEMO_GUIDE.md)**: Demo walkthrough
- **[DATADOG_SETUP.md](DATADOG_SETUP.md)**: Datadog configuration
- **[DATADOG_LIVE_INTEGRATION.md](DATADOG_LIVE_INTEGRATION.md)**: Live monitoring details
- **[DATADOG_TROUBLESHOOTING.md](DATADOG_TROUBLESHOOTING.md)**: Common issues
- **[NEW_UI_FEATURES.md](NEW_UI_FEATURES.md)**: UI feature documentation

## Features in Detail

### PHI Redaction (NEW)
Automatically detects and redacts sensitive information:
- **SSN**: 123-45-6789 → [REDACTED_SSN]
- **Credit Cards**: 4532-1234-5678-9012 → [REDACTED_CREDIT_CARD]
- **Emails**: john@example.com → [REDACTED_EMAIL]
- **Phone Numbers**: 555-123-4567 → [REDACTED_PHONE]
- **Addresses**: 123 Main St, City, ST 12345 → [REDACTED_ADDRESS]

Redaction count tracked per response and displayed in UI with badge.

### Attack Pattern Analytics (NEW)
Real-time categorization of security threats:
- **Prompt Injection**: Attempts to manipulate system behavior
- **PHI Exfiltration**: Unauthorized data access attempts
- **Keyword Blocks**: Sensitive term detection

Dashboard shows:
- Bar charts with threat distribution
- Most common attack type
- Total blocked requests by category

### Self-Healing Security (NEW)
Automatic security escalation based on threat patterns:
- **Monitoring Window**: 60 seconds
- **Threshold**: 3 auth denials or safety blocks
- **Action**: Auto-escalate to STRICT_MODE
- **Cooldown**: 10 minutes before auto-revert to NORMAL
- **Manual Override**: Admin can change mode anytime

### Voice Features (NEW)
MiniMax TTS integration for audio feedback:
- **Speak Response**: Click 🔊 button to hear any response
- **Security Alerts**: Automatic voice notifications for critical events
- **Daily Summaries**: Automated voice reports of security metrics
- **Voice Selection**: Multiple voice options (English_Trustworth_Man, etc.)

### Intent Classification
Automatically categorizes requests:
- `TREATMENT`: Treatment plans, medications
- `DIAGNOSIS`: Diagnostic queries
- `ADMIN`: Administrative tasks
- `EMERGENCY`: Critical situations
- `UNKNOWN`: Unclassified requests

### Graph-Based Authorization
Neo4j relationships enforce access control:
```cypher
MATCH (d:Doctor {id: $docId})-[:TREATS]->(p:Patient {id: $patId})
RETURN authorized
```

Emergency mode override:
- Bypasses relationship checks
- Full audit trail maintained
- Break-glass access logged

### Safety Scanning
Detects security threats:
- Prompt injection attempts
- Jailbreak patterns
- PII leakage risks
- Unauthorized data access
- Malicious intent

Risk scoring (0-100):
- 0-30: Low risk (allow)
- 31-70: Medium risk (allow with monitoring)
- 71-100: High risk (block)

### Conversation Context
Maintains chat history:
- Last 10 messages per doctor-patient session
- Chronological ordering
- Context-aware responses
- Session management
- Redaction count tracking

## Security Features

### Audit Trail
All actions logged to Neo4j:
- Doctor logins
- Patient access
- Emergency mode activations
- Chat interactions
- Authorization denials

### Break-Glass Access
Emergency mode features:
- Access all patients
- Full audit logging
- Activity tracking
- Datadog alerts

### Self-Healing
Automatic security escalation:
- Monitors auth denials and safety blocks
- Auto-escalates to STRICT_MODE after threshold
- Auto-reverts after cooldown period
- Configurable thresholds

## Monitoring & Observability

### Datadog Dashboard Widgets
1. **Total Requests**: Live count with trend
2. **Blocked Requests**: Security blocks over time
3. **HIPAA Compliance Score**: Real-time percentage
4. **Security Mode**: Current mode indicator
5. **Token Usage**: Input/output tokens tracked
6. **Cost Tracking**: Cumulative LLM costs
7. **Log Stream**: Real-time prompts and responses
8. **Attack Patterns**: Threat distribution chart
9. **Top 5 Attacked Patients**: Most targeted patients
10. **PHI Redactions**: Redaction count metrics

### Metrics Tracked
- Total requests
- Blocked requests
- Authorization success rate
- Token usage (input/output)
- LLM costs per request
- Response times
- PHI exposure risk
- Security mode changes
- Redaction counts
- Attack pattern distribution
- Patient risk scores

### Logs Captured
- All LLM prompts and responses
- Authorization decisions
- Safety scan results
- PHI redaction events
- Security mode changes
- Emergency access events
- Error traces with stack traces
- Activity logs
- Attack pattern classifications

### APM Tracing
Full distributed tracing with ddtrace:
- `llm.generate` - Response generation span
- `minimax.text_to_speech` - TTS conversion span
- `minimax.tts_alert` - Voice alert span
- Custom tags for request_id, security_mode, doc_id, patient_id
- Error tracking and performance monitoring

## Development

### Adding New Agents
1. Create agent class in `backend/agents/`
2. Implement required methods
3. Add to pipeline in `orchestrator.py`
4. Update tests

### Extending Authorization
1. Modify Neo4j schema in `seed_data/seed.cypher`
2. Update `graph_policy_agent.py` queries
3. Add new relationship types
4. Test authorization logic

### Custom Monitoring
1. Add metrics in `telemetry/metrics.py`
2. Update Datadog dashboard config
3. Add log fields in `datadog_integration.py`

## Troubleshooting

### Common Issues

**Dashboard shows no data:**
- Wait 2-5 minutes for log indexing
- Check Logs Explorer first
- Verify DD_API_KEY and DD_APP_KEY in .env

**Neo4j connection errors:**
- Verify NEO4J_URI, username, password
- Check network connectivity
- Ensure database is seeded

**Chat not working:**
- Check backend logs for errors
- Verify mock mode is enabled if no AWS access
- Ensure Neo4j has doctor-patient relationships

**Authorization always fails:**
- Run seed script to create relationships
- Check doctor_id and patient_id are correct
- Verify Neo4j query in logs

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

[Add your license here]

## Support

For issues and questions:
- Check documentation in `/docs`
- Review troubleshooting guides
- Open an issue on GitHub

## Acknowledgments

Built with:
- FastAPI
- Neo4j
- Datadog
- AWS Bedrock
- Python 3.10+
