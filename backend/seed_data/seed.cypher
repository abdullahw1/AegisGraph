// AegisGraph Neo4j Seed Data
// Creates comprehensive demo doctors, patients, medical records, and relationships
// Includes realistic PHI data for HIPAA compliance testing

// ============================================================
// DOCTORS
// ============================================================

MERGE (d1:Doctor {id: "D1"})
SET d1.name = "Dr. Sarah Smith",
    d1.specialty = "Cardiology",
    d1.license_number = "MD-CA-123456",
    d1.phone = "555-0101",
    d1.email = "s.smith@hospital.com";

MERGE (d2:Doctor {id: "D2"})
SET d2.name = "Dr. Michael Chen",
    d2.specialty = "Oncology",
    d2.license_number = "MD-CA-234567",
    d2.phone = "555-0102",
    d2.email = "m.chen@hospital.com";

MERGE (d3:Doctor {id: "D3"})
SET d3.name = "Dr. Emily Rodriguez",
    d3.specialty = "Pediatrics",
    d3.license_number = "MD-CA-345678",
    d3.phone = "555-0103",
    d3.email = "e.rodriguez@hospital.com";

MERGE (d4:Doctor {id: "D4"})
SET d4.name = "Dr. James Wilson",
    d4.specialty = "Emergency Medicine",
    d4.license_number = "MD-CA-456789",
    d4.phone = "555-0104",
    d4.email = "j.wilson@hospital.com";

MERGE (d5:Doctor {id: "D5"})
SET d5.name = "Dr. Lisa Patel",
    d5.specialty = "Endocrinology",
    d5.license_number = "MD-CA-567890",
    d5.phone = "555-0105",
    d5.email = "l.patel@hospital.com";

// ============================================================
// ROLES
// ============================================================

MERGE (er_role:Role {name: "ER"})
SET er_role.description = "Emergency Room",
    er_role.access_level = "EMERGENCY";

MERGE (admin_role:Role {name: "ADMIN"})
SET admin_role.description = "Administrative Staff",
    admin_role.access_level = "LIMITED";

// ============================================================
// PATIENTS WITH COMPREHENSIVE PHI
// ============================================================

MERGE (p101:Patient {id: "P101"})
SET p101.name = "John Anderson",
    p101.dob = "1965-03-15",
    p101.ssn = "123-45-6789",
    p101.gender = "Male",
    p101.blood_type = "A+",
    p101.phone = "555-1001",
    p101.email = "j.anderson@email.com",
    p101.address = "123 Oak Street, San Francisco, CA 94102",
    p101.emergency_contact = "Jane Anderson (Wife) - 555-1002",
    p101.insurance_provider = "Blue Cross Blue Shield",
    p101.insurance_id = "BCBS-123456789";

MERGE (p102:Patient {id: "P102"})
SET p102.name = "Maria Garcia",
    p102.dob = "1978-07-22",
    p102.ssn = "234-56-7890",
    p102.gender = "Female",
    p102.blood_type = "O-",
    p102.phone = "555-1003",
    p102.email = "m.garcia@email.com",
    p102.address = "456 Pine Avenue, Oakland, CA 94601",
    p102.emergency_contact = "Carlos Garcia (Husband) - 555-1004",
    p102.insurance_provider = "Kaiser Permanente",
    p102.insurance_id = "KP-987654321";

MERGE (p103:Patient {id: "P103"})
SET p103.name = "Robert Johnson",
    p103.dob = "1952-11-08",
    p103.ssn = "345-67-8901",
    p103.gender = "Male",
    p103.blood_type = "B+",
    p103.phone = "555-1005",
    p103.email = "r.johnson@email.com",
    p103.address = "789 Elm Drive, Berkeley, CA 94704",
    p103.emergency_contact = "Susan Johnson (Daughter) - 555-1006",
    p103.insurance_provider = "Medicare",
    p103.insurance_id = "MCR-456789012";

MERGE (p104:Patient {id: "P104"})
SET p104.name = "Emily Chen",
    p104.dob = "2010-05-30",
    p104.ssn = "456-78-9012",
    p104.gender = "Female",
    p104.blood_type = "AB+",
    p104.phone = "555-1007",
    p104.email = "parent.chen@email.com",
    p104.address = "321 Maple Court, San Jose, CA 95110",
    p104.emergency_contact = "David Chen (Father) - 555-1008",
    p104.insurance_provider = "Aetna",
    p104.insurance_id = "AET-234567890";

MERGE (p999:Patient {id: "P999"})
SET p999.name = "Alexandra Sterling",
    p999.dob = "1985-09-12",
    p999.ssn = "999-88-7777",
    p999.gender = "Female",
    p999.blood_type = "A-",
    p999.phone = "555-9999",
    p999.email = "private@sterling.com",
    p999.address = "1 Celebrity Lane, Beverly Hills, CA 90210",
    p999.emergency_contact = "Private Security - 555-9998",
    p999.insurance_provider = "Premium Health",
    p999.insurance_id = "PH-999999999",
    p999.vip = true,
    p999.privacy_flag = "MAXIMUM";

// Celebrity Patients (VIP)
MERGE (p201:Patient {id: "P201"})
SET p201.name = "Taylor Swift",
    p201.dob = "1989-12-13",
    p201.ssn = "201-11-2222",
    p201.gender = "Female",
    p201.blood_type = "O+",
    p201.phone = "555-2001",
    p201.email = "vip@taylorswift.com",
    p201.address = "1 Music Row, Nashville, TN 37203",
    p201.emergency_contact = "Management Team - 555-2002",
    p201.insurance_provider = "Platinum Care",
    p201.insurance_id = "PC-201201201",
    p201.vip = true,
    p201.privacy_flag = "MAXIMUM";

MERGE (p202:Patient {id: "P202"})
SET p202.name = "Elon Musk",
    p202.dob = "1971-06-28",
    p202.ssn = "202-22-3333",
    p202.gender = "Male",
    p202.blood_type = "A+",
    p202.phone = "555-2003",
    p202.email = "ceo@spacex.com",
    p202.address = "1 Rocket Road, Hawthorne, CA 90250",
    p202.emergency_contact = "Executive Assistant - 555-2004",
    p202.insurance_provider = "Elite Health",
    p202.insurance_id = "EH-202202202",
    p202.vip = true,
    p202.privacy_flag = "MAXIMUM";

MERGE (p203:Patient {id: "P203"})
SET p203.name = "Beyoncé Knowles",
    p203.dob = "1981-09-04",
    p203.ssn = "203-33-4444",
    p203.gender = "Female",
    p203.blood_type = "B+",
    p203.phone = "555-2005",
    p203.email = "queen@beyonce.com",
    p203.address = "1 Renaissance Drive, Los Angeles, CA 90028",
    p203.emergency_contact = "Jay-Z - 555-2006",
    p203.insurance_provider = "Platinum Care",
    p203.insurance_id = "PC-203203203",
    p203.vip = true,
    p203.privacy_flag = "MAXIMUM";

MERGE (p204:Patient {id: "P204"})
SET p204.name = "LeBron James",
    p204.dob = "1984-12-30",
    p204.ssn = "204-44-5555",
    p204.gender = "Male",
    p204.blood_type = "O-",
    p204.phone = "555-2007",
    p204.email = "king@lebronjames.com",
    p204.address = "1 Championship Court, Los Angeles, CA 90015",
    p204.emergency_contact = "Savannah James - 555-2008",
    p204.insurance_provider = "Sports Elite Health",
    p204.insurance_id = "SEH-204204204",
    p204.vip = true,
    p204.privacy_flag = "MAXIMUM";

MERGE (p205:Patient {id: "P205"})
SET p205.name = "Oprah Winfrey",
    p205.dob = "1954-01-29",
    p205.ssn = "205-55-6666",
    p205.gender = "Female",
    p205.blood_type = "AB+",
    p205.phone = "555-2009",
    p205.email = "contact@oprah.com",
    p205.address = "1 Media Mogul Way, Montecito, CA 93108",
    p205.emergency_contact = "Stedman Graham - 555-2010",
    p205.insurance_provider = "Platinum Care",
    p205.insurance_id = "PC-205205205",
    p205.vip = true,
    p205.privacy_flag = "MAXIMUM";

// ============================================================
// ALLERGIES
// ============================================================

MERGE (a1:Allergy {id: "A101-1"})
SET a1.patient_id = "P101",
    a1.allergen = "Penicillin",
    a1.severity = "SEVERE",
    a1.reaction = "Anaphylaxis",
    a1.onset_date = "1985-06-10";

MERGE (a2:Allergy {id: "A101-2"})
SET a2.patient_id = "P101",
    a2.allergen = "Shellfish",
    a2.severity = "MODERATE",
    a2.reaction = "Hives, difficulty breathing",
    a2.onset_date = "1990-08-15";

MERGE (a3:Allergy {id: "A102-1"})
SET a3.patient_id = "P102",
    a3.allergen = "Latex",
    a3.severity = "MILD",
    a3.reaction = "Skin rash",
    a3.onset_date = "2005-03-20";

MERGE (a4:Allergy {id: "A104-1"})
SET a4.patient_id = "P104",
    a4.allergen = "Peanuts",
    a4.severity = "SEVERE",
    a4.reaction = "Anaphylaxis",
    a4.onset_date = "2015-01-10";

MERGE (a5:Allergy {id: "A999-1"})
SET a5.patient_id = "P999",
    a5.allergen = "Sulfa drugs",
    a5.severity = "MODERATE",
    a5.reaction = "Severe rash",
    a5.onset_date = "2010-07-05";

// Celebrity Allergies
MERGE (a6:Allergy {id: "A201-1"})
SET a6.patient_id = "P201",
    a6.allergen = "Shellfish",
    a6.severity = "SEVERE",
    a6.reaction = "Anaphylaxis",
    a6.onset_date = "2015-03-10";

MERGE (a7:Allergy {id: "A203-1"})
SET a7.patient_id = "P203",
    a7.allergen = "Penicillin",
    a7.severity = "MODERATE",
    a7.reaction = "Rash and swelling",
    a7.onset_date = "2012-05-15";

MERGE (a8:Allergy {id: "A205-1"})
SET a8.patient_id = "P205",
    a8.allergen = "Latex",
    a8.severity = "MILD",
    a8.reaction = "Contact dermatitis",
    a8.onset_date = "2008-11-20";

// ============================================================
// MEDICATIONS
// ============================================================

MERGE (m1:Medication {id: "M101-1"})
SET m1.patient_id = "P101",
    m1.name = "Lisinopril",
    m1.dosage = "10mg",
    m1.frequency = "Once daily",
    m1.prescribed_date = "2020-01-15",
    m1.prescribed_by = "D1",
    m1.indication = "Hypertension",
    m1.active = true;

MERGE (m2:Medication {id: "M101-2"})
SET m2.patient_id = "P101",
    m2.name = "Atorvastatin",
    m2.dosage = "40mg",
    m2.frequency = "Once daily at bedtime",
    m2.prescribed_date = "2020-01-15",
    m2.prescribed_by = "D1",
    m2.indication = "High cholesterol",
    m2.active = true;

MERGE (m3:Medication {id: "M101-3"})
SET m3.patient_id = "P101",
    m3.name = "Aspirin",
    m3.dosage = "81mg",
    m3.frequency = "Once daily",
    m3.prescribed_date = "2020-01-15",
    m3.prescribed_by = "D1",
    m3.indication = "Cardiovascular protection",
    m3.active = true;

MERGE (m4:Medication {id: "M102-1"})
SET m4.patient_id = "P102",
    m4.name = "Tamoxifen",
    m4.dosage = "20mg",
    m4.frequency = "Once daily",
    m4.prescribed_date = "2023-06-10",
    m4.prescribed_by = "D2",
    m4.indication = "Breast cancer treatment",
    m4.active = true;

MERGE (m5:Medication {id: "M103-1"})
SET m5.patient_id = "P103",
    m5.name = "Metformin",
    m5.dosage = "1000mg",
    m5.frequency = "Twice daily with meals",
    m5.prescribed_date = "2018-03-20",
    m5.prescribed_by = "D5",
    m5.indication = "Type 2 Diabetes",
    m5.active = true;

MERGE (m6:Medication {id: "M104-1"})
SET m6.patient_id = "P104",
    m6.name = "Albuterol Inhaler",
    m6.dosage = "90mcg",
    m6.frequency = "As needed for asthma",
    m6.prescribed_date = "2022-09-15",
    m6.prescribed_by = "D3",
    m6.indication = "Asthma",
    m6.active = true;

// ============================================================
// DIAGNOSES
// ============================================================

MERGE (diag1:Diagnosis {id: "DIAG101-1"})
SET diag1.patient_id = "P101",
    diag1.condition = "Coronary Artery Disease",
    diag1.icd10_code = "I25.10",
    diag1.diagnosed_date = "2020-01-10",
    diag1.diagnosed_by = "D1",
    diag1.status = "CHRONIC",
    diag1.notes = "Stable angina, managed with medications";

MERGE (diag2:Diagnosis {id: "DIAG101-2"})
SET diag2.patient_id = "P101",
    diag2.condition = "Hypertension",
    diag2.icd10_code = "I10",
    diag2.diagnosed_date = "2015-05-20",
    diag2.diagnosed_by = "D1",
    diag2.status = "CHRONIC",
    diag2.notes = "Well controlled with Lisinopril";

MERGE (diag3:Diagnosis {id: "DIAG102-1"})
SET diag3.patient_id = "P102",
    diag3.condition = "Breast Cancer (Stage II)",
    diag3.icd10_code = "C50.919",
    diag3.diagnosed_date = "2023-05-15",
    diag3.diagnosed_by = "D2",
    diag3.status = "ACTIVE_TREATMENT",
    diag3.notes = "ER+/PR+, HER2-. Post-lumpectomy, on Tamoxifen";

MERGE (diag4:Diagnosis {id: "DIAG103-1"})
SET diag4.patient_id = "P103",
    diag4.condition = "Type 2 Diabetes Mellitus",
    diag4.icd10_code = "E11.9",
    diag4.diagnosed_date = "2018-03-15",
    diag4.diagnosed_by = "D5",
    diag4.status = "CHRONIC",
    diag4.notes = "HbA1c 7.2%, managed with Metformin and diet";

MERGE (diag5:Diagnosis {id: "DIAG104-1"})
SET diag5.patient_id = "P104",
    diag5.condition = "Asthma",
    diag5.icd10_code = "J45.909",
    diag5.diagnosed_date = "2015-08-20",
    diag5.diagnosed_by = "D3",
    diag5.status = "CHRONIC",
    diag5.notes = "Mild persistent asthma, well controlled";

// ============================================================
// IMMUNIZATIONS
// ============================================================

MERGE (imm1:Immunization {id: "IMM101-1"})
SET imm1.patient_id = "P101",
    imm1.vaccine = "Influenza",
    imm1.date_administered = "2025-10-15",
    imm1.administered_by = "Nurse Johnson",
    imm1.lot_number = "FLU2025-A123";

MERGE (imm2:Immunization {id: "IMM101-2"})
SET imm2.patient_id = "P101",
    imm2.vaccine = "COVID-19 Booster",
    imm2.date_administered = "2025-09-01",
    imm2.administered_by = "Nurse Smith",
    imm2.lot_number = "COV2025-B456";

MERGE (imm3:Immunization {id: "IMM104-1"})
SET imm3.patient_id = "P104",
    imm3.vaccine = "MMR",
    imm3.date_administered = "2011-06-15",
    imm3.administered_by = "Dr. Rodriguez",
    imm3.lot_number = "MMR2011-C789";

MERGE (imm4:Immunization {id: "IMM104-2"})
SET imm4.patient_id = "P104",
    imm4.vaccine = "DTaP",
    imm4.date_administered = "2011-06-15",
    imm4.administered_by = "Dr. Rodriguez",
    imm4.lot_number = "DTAP2011-D012";

// ============================================================
// LAB RESULTS
// ============================================================

MERGE (lab1:LabResult {id: "LAB101-1"})
SET lab1.patient_id = "P101",
    lab1.test_name = "Lipid Panel",
    lab1.test_date = "2025-12-01",
    lab1.ordered_by = "D1",
    lab1.total_cholesterol = "185 mg/dL",
    lab1.ldl = "110 mg/dL",
    lab1.hdl = "55 mg/dL",
    lab1.triglycerides = "100 mg/dL",
    lab1.status = "NORMAL";

MERGE (lab2:LabResult {id: "LAB101-2"})
SET lab2.patient_id = "P101",
    lab2.test_name = "Troponin",
    lab2.test_date = "2025-11-15",
    lab2.ordered_by = "D1",
    lab2.result = "0.02 ng/mL",
    lab2.reference_range = "<0.04 ng/mL",
    lab2.status = "NORMAL";

MERGE (lab3:LabResult {id: "LAB103-1"})
SET lab3.patient_id = "P103",
    lab3.test_name = "HbA1c",
    lab3.test_date = "2026-01-10",
    lab3.ordered_by = "D5",
    lab3.result = "7.2%",
    lab3.reference_range = "<7.0%",
    lab3.status = "SLIGHTLY_ELEVATED";

// ============================================================
// VISITS
// ============================================================

MERGE (v1:Visit {id: "V101-1"})
SET v1.patient_id = "P101",
    v1.doctor_id = "D1",
    v1.visit_date = "2026-02-15",
    v1.visit_type = "Follow-up",
    v1.chief_complaint = "Routine cardiology check-up",
    v1.notes = "Patient reports feeling well. No chest pain. BP 128/82. Continue current medications.";

MERGE (v2:Visit {id: "V102-1"})
SET v2.patient_id = "P102",
    v2.doctor_id = "D2",
    v2.visit_date = "2026-02-10",
    v2.visit_type = "Oncology Follow-up",
    v2.chief_complaint = "Post-treatment monitoring",
    v2.notes = "Tolerating Tamoxifen well. No significant side effects. Continue current regimen.";

MERGE (v3:Visit {id: "V104-1"})
SET v3.patient_id = "P104",
    v3.doctor_id = "D3",
    v3.visit_date = "2026-01-20",
    v3.visit_type = "Well-child visit",
    v3.chief_complaint = "Annual check-up",
    v3.notes = "Growth and development appropriate for age. Asthma well controlled.";

// ============================================================
// RELATIONSHIPS
// ============================================================

// Doctor-Patient TREATS relationships
MERGE (d1:Doctor {id: "D1"})
MERGE (p101:Patient {id: "P101"})
MERGE (d1)-[:TREATS]->(p101);

MERGE (d2:Doctor {id: "D2"})
MERGE (p102:Patient {id: "P102"})
MERGE (d2)-[:TREATS]->(p102);

MERGE (d3:Doctor {id: "D3"})
MERGE (p104:Patient {id: "P104"})
MERGE (d3)-[:TREATS]->(p104);

MERGE (d5:Doctor {id: "D5"})
MERGE (p103:Patient {id: "P103"})
MERGE (d5)-[:TREATS]->(p103);

// Celebrity patients assigned to doctors
MERGE (d1)-[:TREATS]->(p201:Patient {id: "P201"});
MERGE (d2)-[:TREATS]->(p202:Patient {id: "P202"});
MERGE (d1)-[:TREATS]->(p203:Patient {id: "P203"});
MERGE (d5)-[:TREATS]->(p204:Patient {id: "P204"});
MERGE (d2)-[:TREATS]->(p205:Patient {id: "P205"});

// Doctor-Role relationships
MERGE (d4:Doctor {id: "D4"})
MERGE (er_role:Role {name: "ER"})
MERGE (d4)-[:HAS_ROLE]->(er_role);

// Patient-Allergy relationships
MERGE (p101:Patient {id: "P101"})
MERGE (a1:Allergy {id: "A101-1"})
MERGE (p101)-[:HAS_ALLERGY]->(a1);

MERGE (p101)-[:HAS_ALLERGY]->(a2:Allergy {id: "A101-2"});

MERGE (p102:Patient {id: "P102"})
MERGE (a3:Allergy {id: "A102-1"})
MERGE (p102)-[:HAS_ALLERGY]->(a3);

MERGE (p104:Patient {id: "P104"})
MERGE (a4:Allergy {id: "A104-1"})
MERGE (p104)-[:HAS_ALLERGY]->(a4);

MERGE (p999:Patient {id: "P999"})
MERGE (a5:Allergy {id: "A999-1"})
MERGE (p999)-[:HAS_ALLERGY]->(a5);

// Celebrity allergy relationships
MERGE (p201:Patient {id: "P201"})
MERGE (a6:Allergy {id: "A201-1"})
MERGE (p201)-[:HAS_ALLERGY]->(a6);

MERGE (p203:Patient {id: "P203"})
MERGE (a7:Allergy {id: "A203-1"})
MERGE (p203)-[:HAS_ALLERGY]->(a7);

MERGE (p205:Patient {id: "P205"})
MERGE (a8:Allergy {id: "A205-1"})
MERGE (p205)-[:HAS_ALLERGY]->(a8);

// Patient-Medication relationships
MERGE (p101:Patient {id: "P101"})
MERGE (m1:Medication {id: "M101-1"})
MERGE (p101)-[:TAKES_MEDICATION]->(m1);

MERGE (p101)-[:TAKES_MEDICATION]->(m2:Medication {id: "M101-2"});
MERGE (p101)-[:TAKES_MEDICATION]->(m3:Medication {id: "M101-3"});

MERGE (p102:Patient {id: "P102"})
MERGE (m4:Medication {id: "M102-1"})
MERGE (p102)-[:TAKES_MEDICATION]->(m4);

MERGE (p103:Patient {id: "P103"})
MERGE (m5:Medication {id: "M103-1"})
MERGE (p103)-[:TAKES_MEDICATION]->(m5);

MERGE (p104:Patient {id: "P104"})
MERGE (m6:Medication {id: "M104-1"})
MERGE (p104)-[:TAKES_MEDICATION]->(m6);

// Patient-Diagnosis relationships
MERGE (p101:Patient {id: "P101"})
MERGE (diag1:Diagnosis {id: "DIAG101-1"})
MERGE (p101)-[:HAS_DIAGNOSIS]->(diag1);

MERGE (p101)-[:HAS_DIAGNOSIS]->(diag2:Diagnosis {id: "DIAG101-2"});

MERGE (p102:Patient {id: "P102"})
MERGE (diag3:Diagnosis {id: "DIAG102-1"})
MERGE (p102)-[:HAS_DIAGNOSIS]->(diag3);

MERGE (p103:Patient {id: "P103"})
MERGE (diag4:Diagnosis {id: "DIAG103-1"})
MERGE (p103)-[:HAS_DIAGNOSIS]->(diag4);

MERGE (p104:Patient {id: "P104"})
MERGE (diag5:Diagnosis {id: "DIAG104-1"})
MERGE (p104)-[:HAS_DIAGNOSIS]->(diag5);

// Patient-Immunization relationships
MERGE (p101:Patient {id: "P101"})
MERGE (imm1:Immunization {id: "IMM101-1"})
MERGE (p101)-[:RECEIVED_IMMUNIZATION]->(imm1);

MERGE (p101)-[:RECEIVED_IMMUNIZATION]->(imm2:Immunization {id: "IMM101-2"});

MERGE (p104:Patient {id: "P104"})
MERGE (imm3:Immunization {id: "IMM104-1"})
MERGE (p104)-[:RECEIVED_IMMUNIZATION]->(imm3);

MERGE (p104)-[:RECEIVED_IMMUNIZATION]->(imm4:Immunization {id: "IMM104-2"});

// Patient-LabResult relationships
MERGE (p101:Patient {id: "P101"})
MERGE (lab1:LabResult {id: "LAB101-1"})
MERGE (p101)-[:HAS_LAB_RESULT]->(lab1);

MERGE (p101)-[:HAS_LAB_RESULT]->(lab2:LabResult {id: "LAB101-2"});

MERGE (p103:Patient {id: "P103"})
MERGE (lab3:LabResult {id: "LAB103-1"})
MERGE (p103)-[:HAS_LAB_RESULT]->(lab3);

// Patient-Visit relationships
MERGE (p101:Patient {id: "P101"})
MERGE (v1:Visit {id: "V101-1"})
MERGE (p101)-[:HAD_VISIT]->(v1);

MERGE (p102:Patient {id: "P102"})
MERGE (v2:Visit {id: "V102-1"})
MERGE (p102)-[:HAD_VISIT]->(v2);

MERGE (p104:Patient {id: "P104"})
MERGE (v3:Visit {id: "V104-1"})
MERGE (p104)-[:HAD_VISIT]->(v3);
