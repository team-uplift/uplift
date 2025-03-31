List<Map<String, dynamic>> registrationQuestions = [
  // ABOUT ME
  {
    'key': 'aboutMe',
    'q': 'Tell us about yourself.',
    'type': 'text',
  },

  // CHALLENGES & NEEDS
  // {
  //   'key': 'mostDifficultThing',
  //   'q': 'What is the most difficult thing you face day to day?',
  //   'type': 'text',
  // },
  // {
  //   'key': 'financialHardship',
  //   'q': 'What has been the hardest thing for you financially this year?',
  //   'type': 'multipleChoice',
  //   'options': ['Job loss', 'Medical bills', 'Rent/mortgage', 'Debt', 'Other'],
  // },
  // {
  //   'key': 'jobSeeking',
  //   'q': 'Are you currently looking for work?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes, full-time', 'Yes, part-time', 'No, unable to work', 'No, not needed'],
  // },
  // {
  //   'key': 'workBarriers',
  //   'q': 'What barriers are preventing you from working or earning more income?',
  //   'type': 'checkbox',
  //   'options': ['Childcare', 'Transportation', 'Disability', 'Job training', 'No job openings'],
  // },
  // {
  //   'key': 'housingChallenge',
  //   'q': 'What is your biggest challenge related to housing?',
  //   'type': 'multipleChoice',
  //   'options': ['High rent', 'Unsafe conditions', 'Lack of stability', 'Other'],
  // },
  // {
  //   'key': 'housingRisk',
  //   'q': 'Are you at risk of losing housing in the next 3 months?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  // },
  // {
  //   'key': 'supportSystem',
  //   'q': 'Do you have a support system of friends, family, or community?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  // },
  // {
  //   'key': 'supportNeeded',
  //   'q': 'What kind of support do you wish you had more of?',
  //   'type': 'checkbox',
  //   'options': ['Emotional', 'Financial', 'Housing', 'Legal'],
  // },
  // {
  //   'key': 'mentalHealthAccess',
  //   'q': 'Do you have regular access to mental health support or counseling?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  // },
  {
    'key': 'emotionalChallenge',
    'q': 'What has been the most emotionally difficult part of your current situation?',
    'type': 'text',
  },
  
  // 🏷️ TAG SELECTION
  // TODO potentailly remove tag selection from here although it would be nice if they were all grouped together like this
  // {
  //   'key': 'tags',
  //   'q': 'Select up to 10 interests or areas that describe you.',
  //   'type': 'tagSelection', // Special UI
  // },
  
  
  
  
  {
    'key': 'generateTags',
    'q': 'Click "Generate Tags" to proceed to tag selection.',
    'type': 'generateTags', // Special type to handle separately
  },

  {
    'key': 'showTags',
    'q': '',
    'type': 'showTags', // Special type to handle separately
  },

  // ✅ CONFIRMATION STEP
  {
    'key': 'confirmation',
    'q': 'Review your answers before submitting.',
    'type': 'confirmation',
  },
];