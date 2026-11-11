class StudentProfile {
  StudentProfile._();

  static const name = 'Jahidul Islam';
  static const initials = 'JI';
  static const university = 'East West University';
  static const studentId = '2023-2-60-053';
  static const department = 'Computer Science and Engineering (CSE)';
  static const degree =
      'Bachelor of Science in Computer Science and Engineering (B.Sc. in CSE)';
  static const semester = '11th Semester';
  static const academicYear = 'Final Year';
  static const batch = 'Summer 2023';
  static const admissionDate = '28 May 2023';
  static const graduationYear = '2027';
  static const cgpa = '3.52';
  static const completedCredits = '104';
  static const birthDate = '14 December 2000';
  static const gender = 'Male';
  static const nationality = 'Bangladeshi';
  static const bloodGroup = 'A+';
  static const personalEmail = 'rabbyjahidulislam5@gmail.com';
  static const universityEmail = '2023-2-60-053@std.ewubd.edu';
  static const phone = '01787037483';
  static const city = 'Dhaka';
  static const country = 'Bangladesh';
  static const address = 'Khan property, house no 391, ghulbagh';
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

  static const Map<String, List<String>> skillGroups = {
    'Programming Languages': ['Java', 'C++', 'JavaScript', 'TypeScript'],
    'Web Technologies': ['HTML', 'CSS'],
    'Frameworks and Runtime Technologies': ['Flutter', 'Node.js', 'Express.js'],
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

  static const projects = [
    ProfileProject(
      title: 'Caregiver & Care Provider Web Application',
      type: 'Web Application',
      category: 'Academic Project',
      description:
          'A web application project developed around caregiver and care-provider '
          'services, bringing caregiver and service-provider related information '
          'and interactions into a unified web-based platform.',
    ),
    ProfileProject(
      title: 'East West University Centralized Payment System',
      type: 'University Payment Management Web Application',
      category: 'Academic Project',
      description:
          'A centralized university payment management system designed to bring '
          'multiple student and university-related payments into one unified '
          'platform. The project focuses on organizing payments such as tuition '
          'fees, library fines, and other university fees and charges in one '
          'convenient system, reducing the need to manage different payment '
          'categories separately.',
    ),
  ];
}

class ProfileProject {
  const ProfileProject({
    required this.title,
    required this.type,
    required this.category,
    required this.description,
  });

  final String title;
  final String type;
  final String category;
  final String description;
}
