// list of all questions for recipient registration
// type is used to determine which field type is generated on the form
// required can be toggled to false if we do not need answers to those questions
// additional options for multiple choice questions can be added under the 'options' list

List<Map<String, dynamic>> registrationQuestions = [
  // boiler plate location information
  {
    'key': 'basicAddressInfo',
    'type': 'compositeAddress',
    'q': 'Tell us where you’re currently living.',
    'required': true,
  },

  // required questions for profile building
  {
    'key': 'lastAboutMe',
    'q': 'Tell us about yourself.',
    'type': 'text',
    'required': true,
  },
  {
    'key': 'lastReasonForHelp',
    'q': 'What is the biggest reason that you feel like you need help?',
    'type': 'text',
    'required': true,
  },

  // additional questions to further refine tag generation
  // {
  //   'key': 'mostDifficultThing',
  //   'q': 'What is the most difficult thing you face day to day?',
  //   'type': 'text',
  //   'required': true,
  // },
  {
    'key': 'financialHardship',
    'q': 'What has been the hardest thing for you financially this year?',
    'type': 'multipleChoice',
    'options': ['Job loss', 'Medical bills', 'Rent/mortgage', 'Debt', 'Other'],
    'required': true,
  },
  {
    'key': 'jobSeeking',
    'q': 'Are you currently looking for work?',
    'type': 'multipleChoice',
    'options': ['Yes, full-time', 'Yes, part-time', 'No, unable to work', 'No, not needed'],
    'required': true,
  },
  {
    'key': 'workBarriers',
    'q': 'What barriers are preventing you from working or earning more income?',
    'type': 'checkbox',
    'options': ['Childcare', 'Transportation', 'Disability', 'Job training', 'No job openings'],
    'required': true,
  },
  // {
  //   'key': 'housingChallenge',
  //   'q': 'What is your biggest challenge related to housing?',
  //   'type': 'multipleChoice',
  //   'options': ['High rent', 'Unsafe conditions', 'Lack of stability', 'Other'],
  //   'required': true,
  // },
  // {
  //   'key': 'housingRisk',
  //   'q': 'Are you at risk of losing housing in the next 3 months?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  //   'required': true,
  // },
  // {
  //   'key': 'supportSystem',
  //   'q': 'Do you have a support system of friends, family, or community?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  //   'required': true,
  // },
  // {
  //   'key': 'supportNeeded',
  //   'q': 'What kind of support do you wish you had more of?',
  //   'type': 'checkbox',
  //   'options': ['Emotional', 'Financial', 'Housing', 'Legal'],
  //   'required': true,
  // },
  // {
  //   'key': 'mentalHealthAccess',
  //   'q': 'Do you have regular access to mental health support or counseling?',
  //   'type': 'multipleChoice',
  //   'options': ['Yes', 'No'],
  //   'required': true,
  // },
  // {
  //   'key': 'emotionalChallenge',
  //   'q': 'What has been the most emotionally difficult part of your current situation?',
  //   'type': 'text',
  //   'required': true,
  // },

  // last step to show answers before generating tags
  {
    'key': 'confirmation',
    'q': 'Review your answers before submitting.',
    'type': 'confirmation',
  },

  // generated tags selection screen --> not allowed to once this point is reached
  {
    'key': 'showTags',
    'q': '',
    'type': 'showTags',
    'id': 'tags',
  },
];