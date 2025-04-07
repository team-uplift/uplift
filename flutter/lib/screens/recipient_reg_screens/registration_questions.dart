List<Map<String, dynamic>> registrationQuestions = [
  // ABOUT ME
  {
    'key': 'lastAboutMe',
    'q': 'Tell us about yourself.',
    'type': 'text',
    'id': 'special', 
  },
  {
    'key': 'lastReasonForHelp',
    'q': 'What is the biggest reason that you feel like you need help?',
    'type': 'text',
    'id': 'special'
  },

  // CHALLENGES & NEEDS
  {
    'key': 'mostDifficultThing',
    'q': 'What is the most difficult thing you face day to day?',
    'type': 'text',
    'id': 'normal',
  },
  {
    'key': 'financialHardship',
    'q': 'What has been the hardest thing for you financially this year?',
    'type': 'multipleChoice',
    'options': ['Job loss', 'Medical bills', 'Rent/mortgage', 'Debt', 'Other'],
    'id': 'normal',
  },
  {
    'key': 'jobSeeking',
    'q': 'Are you currently looking for work?',
    'type': 'multipleChoice',
    'options': ['Yes, full-time', 'Yes, part-time', 'No, unable to work', 'No, not needed'],
    'id': 'normal',
  },
  {
    'key': 'workBarriers',
    'q': 'What barriers are preventing you from working or earning more income?',
    'type': 'checkbox',
    'options': ['Childcare', 'Transportation', 'Disability', 'Job training', 'No job openings'],
    'id': 'normal',
  },
  {
    'key': 'housingChallenge',
    'q': 'What is your biggest challenge related to housing?',
    'type': 'multipleChoice',
    'options': ['High rent', 'Unsafe conditions', 'Lack of stability', 'Other'],
    'id': 'normal',
  },
  {
    'key': 'housingRisk',
    'q': 'Are you at risk of losing housing in the next 3 months?',
    'type': 'multipleChoice',
    'options': ['Yes', 'No'],
    'id': 'normal',
  },
  {
    'key': 'supportSystem',
    'q': 'Do you have a support system of friends, family, or community?',
    'type': 'multipleChoice',
    'options': ['Yes', 'No'],
    'id': 'normal',
  },
  {
    'key': 'supportNeeded',
    'q': 'What kind of support do you wish you had more of?',
    'type': 'checkbox',
    'options': ['Emotional', 'Financial', 'Housing', 'Legal'],
    'id': 'normal',
  },
  {
    'key': 'mentalHealthAccess',
    'q': 'Do you have regular access to mental health support or counseling?',
    'type': 'multipleChoice',
    'options': ['Yes', 'No'],
    'id': 'normal',
  },
  {
    'key': 'emotionalChallenge',
    'q': 'What has been the most emotionally difficult part of your current situation?',
    'type': 'text',
    'id': 'normal',
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
    'type': 'showTags',
    'id': 'tags', // Special type to handle separately
  },

  // ✅ CONFIRMATION STEP
  {
    'key': 'confirmation',
    'q': 'Review your answers before submitting.',
    'type': 'confirmation',
  },
];