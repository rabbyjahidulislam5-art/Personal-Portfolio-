/// Everything shown in the app. Only details meant for a shareable portfolio
/// belong here: this file ships inside every build.
class StudentProfile {
  StudentProfile._();

  static const name = 'Jahidul Islam';
  static const initials = 'JI';
  static const university = 'East West University';
  static const degree =
      'Bachelor of Science in Computer Science and Engineering (B.Sc. in CSE)';
  static const major = 'Software Engineering';
  static const semester = '11th Semester';
  static const academicYear = 'Final Year';
  static const batch = 'Summer 2023';
  static const admissionDate = '28 May 2023';
  static const graduationYear = '2027';
  static const cgpa = '3.52';

  /// Top of the grading scale. Never an achieved result.
  static const cgpaScale = '4.00';
  static const completedCredits = 104;
  static const totalCredits = 140;
  static const gender = 'Male';
  static const nationality = 'Bangladeshi';
  static const email = 'rabbyjahidulislam5@gmail.com';
  static const universityEmail = '2023-2-60-053@std.ewubd.edu';
  static const phone = '01787037483';
  static const presentAddress =
      'Gulbagh, Khan Property 391, Malibagh, Dhaka, Bangladesh';
  static const permanentAddress =
      'Village: Nilganj, Upazila: Kalapara, Post: Faridganj, '
      'District: Patuakhali, Bangladesh';
  static const profileImage = 'assets/profile.png';

  /// The campus address as printed on ewubd.edu.
  static const universityAddress =
      'A/2, Jahurul Islam Avenue, Jahurul Islam City, Aftabnagar, '
      'Dhaka-1212, Bangladesh';
  static const educationHistory = [
    EducationRecord(
      institution: 'Maizpara Mahmudun Nabi Chowdhury High School',
      qualification: 'SSC',
      group: 'Science',
      board: 'Chittagong',
      academicBatch: '2019–2020',
    ),
    EducationRecord(
      institution: 'Govt. Mozahar Uddin Biswas Degree College, Patuakhali',
      qualification: 'HSC',
      group: 'Science',
      academicBatch: '2021–2022',
    ),
  ];
  static const city = 'Dhaka';
  static const country = 'Bangladesh';
  static const about =
      'I am a final-year Computer Science and Engineering student at East West '
      'University with a strong interest in software development, web '
      'technologies, and mobile application development. I enjoy learning new '
      'technologies and building practical software projects.';
  static const careerGoal =
      'My goal is to build a successful career in the software industry as a '
      'Software Developer, continuously improve my technical skills, and '
      'contribute to developing useful, reliable, and innovative software '
      'solutions.';
  static const githubUrl = 'https://github.com/rabbyjahidulislam5-art';

  /// Course codes and titles from the official EWU CSE curriculum. Shown as
  /// "relevant", not "completed": completion of each course is not recorded.
  static const coursework = [
    ('CSE207', 'Data Structures'),
    ('CSE246', 'Algorithms'),
    ('CSE302', 'Database Systems'),
    ('CSE325', 'Operating Systems'),
    ('CSE347', 'Information System Analysis and Design'),
    ('CSE412', 'Software Engineering'),
    ('CSE430', 'Software Testing and Quality Assurance'),
    ('CSE423', 'Software Architecture'),
    ('CSE479', 'Web Programming'),
    ('CSE489', 'Mobile Programming'),
  ];

  static const Map<String, List<String>> skillGroups = {
    'Programming and Web Technologies': [
      'TypeScript',
      'JavaScript',
      'HTML',
      'CSS',
      'Java',
      'C++',
    ],
    'Frontend and Mobile': ['React', 'Tailwind CSS', 'Flutter'],
    'Backend Development': ['Node.js', 'Express.js', 'Socket.IO'],
    'Database': ['PostgreSQL', 'Prisma'],
    'Payment Integration': ['SSLCOMMERZ'],
    'Development Tools and Platforms': ['GitHub'],
    'Development Areas': [
      'Web Development',
      'Frontend Development',
      'Flutter Mobile UI Development',
      'JavaScript and TypeScript Development',
      'Node.js and Express.js Development',
    ],
  };

  static const softSkills = [
    'Problem Solving',
    'Teamwork and Collaboration',
    'Communication',
    'Adaptability',
    'Time Management',
  ];
  static const technicalInterests = [
    'Artificial Intelligence',
    'App Development',
  ];
  static const hobbies = ['Traveling', 'Exploring Social Media Apps'];

  /// Technology lists match what each linked repository actually uses.
  static const projects = [
    ProfileProject(
      title: 'Caregiver & Care Provider Web Application',
      type: 'Web Application',
      category: 'Academic Project',
      description:
          'A web-based platform designed to connect caregivers and care '
          'seekers through a centralized digital system, with an emphasis on '
          'accessible service coordination and communication.',
      technologies: [
        'TypeScript',
        'JavaScript',
        'React',
        'Node.js',
        'Express.js',
        'PostgreSQL',
        'Prisma',
        'Tailwind CSS',
        'HTML',
        'CSS',
      ],
      repoUrl: 'https://github.com/rabbyjahidulislam5-art/Caregiver.git',
    ),
    ProfileProject(
      title: 'EWU Campus Wallet',
      type: 'Smart Campus Payment System',
      alsoKnownAs: 'East West University Central Payment System',
      category: 'Academic Project',
      description:
          'EWU Campus Wallet is a centralized digital campus payment platform '
          'designed to simplify university-related financial transactions, '
          'including tuition payments, library fines, and campus purchases. '
          'It brings multiple payment services into one system with QR-based '
          'transactions, payment tracking, and dedicated management '
          'interfaces.',
      technologies: [
        'TypeScript',
        'JavaScript',
        'React',
        'Node.js',
        'Express.js',
        'PostgreSQL',
        'Prisma',
        'Socket.IO',
        'SSLCOMMERZ',
        'Tailwind CSS',
        'HTML',
        'CSS',
      ],
      repoUrl:
          'https://github.com/rabbyjahidulislam5-art/EWU-Campus-Wallet.git',
      demoUrl: 'https://youtu.be/CLjAjvE5RWI?si=fdL6OlsjYey84F7B',
    ),
    // Ongoing work: no results, metrics, repository or deployment are claimed.
    ProfileProject(
      title: 'RDIS-HybridNet',
      type: 'Academic Capstone / Research Project',
      category: 'Ongoing Capstone',
      description:
          'RDIS-HybridNet is an academic road-damage analysis project focused '
          'on identifying road surface damage and exploring image-based '
          'approaches to damage assessment and measurement.',
    ),
  ];
}

class EducationRecord {
  const EducationRecord({
    required this.institution,
    required this.qualification,
    required this.group,
    required this.academicBatch,
    this.board,
  });

  final String institution;
  final String qualification;
  final String group;
  final String? board;
  final String academicBatch;
}

class ProfileProject {
  const ProfileProject({
    required this.title,
    required this.type,
    required this.category,
    required this.description,
    this.alsoKnownAs,
    this.technologies = const [],
    this.repoUrl,
    this.demoUrl,
  });

  final String title;
  final String type;
  final String category;
  final String description;
  final String? alsoKnownAs;
  final List<String> technologies;

  /// Link buttons are shown only for the URLs that exist.
  final String? repoUrl;
  final String? demoUrl;
}
