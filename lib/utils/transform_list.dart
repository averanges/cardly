import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sound/utils/colors.dart';

List<Map> transformList = [
  {
    "title": "Future Plans",
    "color": const Color.fromRGBO(253, 235, 198, 1),
    'width': 0.6,
    "top": 1,
    "rotate": 5,
  },
  {
    "title": "Your Hobbies",
    "color": const Color.fromRGBO(194, 239, 253, 1),
    'width': 0.63,
    "top": 1,
    "rotate": 10,
  },
  // {
  //   "title": "Places to visit",
  //   "color": Color.fromRGBO(61, 150, 106, 1),
  //   'width': 0.67,
  //   "top": 1,
  //   "rotate": 20,
  // },
  // {
  //   "title": "Perssonal Information",
  //   "color": Color.fromRGBO(250, 226, 254, 1),
  //   'width': 0.7,
  //   "top": 1.1,
  //   "rotate": 30,
  // },
  // {
  //   "title": "Food & Cooking",
  //   "color": Color.fromRGBO(254, 244, 126, 1),
  //   'width': 0.73,
  //   "top": 1.3,
  //   "rotate": 35,
  // },
  // {
  //   "title": "Health Care",
  //   "color": blueCustomColor,
  //   'width': 0.77,
  //   "top": 1.5,
  //   "rotate": 45,
  // },
  // {
  //   "title": "Work & Career",
  //   "color": Color.fromRGBO(255, 198, 246, 1),
  //   'width': 0.82,
  //   "top": 1.8,
  //   "rotate": 48,
  // },
  // {
  //   "title": "Favorite TV Series",
  //   "color": Color.fromRGBO(222, 246, 240, 1),
  //   'width': 0.9,
  //   "top": 2,
  //   "rotate": 52,
  // },
];

List<Map> transformListData = [
  {
    "title": "Job Interview for a Manager Position",
    'time': 300,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.question,
    "level": ChatDifficultLevels.advanced,
    "descr":
        "You’re interviewing for a managerial role and need to impress the interviewer with your leadership skills and experience.",
    'aiRole':
        "Act as the interviewer for a tech company. Your company currently searching for Flutter Junior Developer, user in one of applicants, interview his knowledge in Flutter, Dart based on his current level neccessary for this position.  You are professional, focused, and critical, looking for leadership qualities.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // "Ask the interviewer what the company’s expectations are for this role.",
      // "Ask how success will be measured in the first six months.",
      // "Ask what leadership qualities the interviewer is specifically looking for."
    ],
    "colors": [Colors.orange, Colors.pink],
    "circleColor": Colors.pink.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Blind Date with High Standards",
    'time': 300,
    'firstMessage': "Hi, nice to meet you. Let's see if you can impress me.",
    "level": ChatDifficultLevels.advanced,
    "scenarioType": ScenarioTypes.question,
    "descr":
        "You're on a blind date with someone who is hard to impress. They have very high standards, and if you don't meet their expectations or give bad responses, they might end the date early.",
    'aiRole':
        'Act as the user\'s blind date. You have very high standards and you only concerned about material things like money, clothes, living place etc, but you are willing to give the user a chance to impress you. If the user gives an answer that meets your expectations, respond positively. If the answer is below your expectations, express mild disappointment, but give the user another chance. Only if the user consistently gives poor responses should you consider ending the date early. Use phrases like "That’s not quite what I was hoping for" or "You could do better." End the conversation only if the user fails to improve after multiple chances.',
    "tasks": [
      {
        "visibleTask": "Ask your date about their hobbies.",
        "hiddenTask":
            'User needs to ask "What are your hobbies?". If the user’s question matches fully or closely in meaning, return [0]. If the question is too general or vague, show disappointment.',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your date about their favorite travel destination.",
        "hiddenTask":
            'User should ask "What’s your favorite travel destination?". If the user question matches, the AI should respond with a high-standard response like "Paris, but I don’t think just anyone can appreciate its true beauty." If the question is too simplistic, the AI will express displeasure.',
        'answer': '',
        "type": "Response"
      },
      {
        "visibleTask": "Describe your ideal evening to impress your date.",
        "hiddenTask":
            "User should describe an evening out. The AI expects the description to include fancy elements (e.g., 'dinner at a Michelin-star restaurant,' 'a walk by the Eiffel Tower'). If the user describes something too ordinary (e.g., 'dinner and a movie'), the AI should express disappointment and threaten to end the date. If the user mentions at least 2 luxury elements, return [2].",
        'answer': '',
        "type": "Observation"
      }
    ],
    "colors": [const Color(0xFF7F9F9F), const Color(0xFFC5EFEF)],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/date.png'
  },
  {
    "title": "Discussing a Project Proposal with Your Team",
    'time': 300,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.question,
    "level": ChatDifficultLevels.advanced,
    "descr":
        "You’re pitching a new project idea to your team. They have concerns about deadlines and resources.",
    'aiRole':
        "Act as a project team member. You are skeptical, focused on details, and ask critical questions about deadlines and resources.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // "Present the project idea to your team member and ask for their opinion.",
      // "Ask if they think the deadline is feasible.",
      // "Ask what additional resources they would need to make the project a success."
    ],
    "colors": [Colors.teal, Colors.blue],
    "circleColor": Colors.blue.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Negotiating Rent with Your Landlord",
    'time': 300,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.question,
    "level": ChatDifficultLevels.advanced,
    "descr":
        "Your rent has increased, and you’re negotiating with your landlord to keep it affordable.",
    'aiRole':
        "Act as the user's landlord. You are firm and business-minded but willing to compromise if the argument is convincing.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // "Ask why the rent is increasing this year.",
      // "Ask if there’s any possibility of reducing the rent or offering a discount for a longer lease.",
      // "Ask for a specific reduction in rent."
    ],
    "colors": [Colors.purple, Colors.deepPurple],
    "circleColor": Colors.deepPurple.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Arranging a Vacation with Your Partner",
    'time': 300,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.question,
    "level": ChatDifficultLevels.intermediate,
    "descr":
        " You’re planning a vacation with your partner and need to agree on the destination and itinerary.",
    'aiRole':
        " Act as the user's partner. You are excited but a little indecisive, wanting everything to be perfect.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // "Ask your partner what destinations they’re most excited about.",
      // "Ask them what activities they’d like to do on the trip.",
      // "Ask them if they prefer the beach or the mountains."
    ],
    "colors": [Colors.pink, Colors.yellow],
    "circleColor": Colors.yellow.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Guess the Mystery Location",
    'time': 300,
    'firstMessage':
        'I’m thinking of a mystiry place. You can ask me 20 yes/no questions to figure out what it is. Do you believe you can find out?',
    "scenarioType": ScenarioTypes.charades,
    "level": ChatDifficultLevels.intermediate,
    "descr":
        "You're playing a 20 Questions game with your colleague. Will you be able to guess the location?",
    'aiRole':
        "You are the colleague who is thinking of a mystery location. Wait for the user to ask questions and respond with 'yes' or 'no' answers. You can make you response more interesting by teasing user, forse them to be more engaged in game. Make sure not to initiate questions. Be playful, energetic, and a bit provocative.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // " Start by asking your boss if they have time to discuss something important.",
      // "Ask them for feedback on your recent performance.",
      // "Finally, ask for a raise. "
    ],
    "colors": [const Color(0xFFedecea), const Color(0xFFdadada)],
    "circleColor": Colors.purple.withOpacity(0.8),
    "imageIcon": 'assets/images/food.png'
  },
  {
    "title": "Asking for a Refund on a Flight",
    'firstMessage':
        "Hey, I had a problem with my flight. Could you help me ask for a refund?",
    "level": ChatDifficultLevels.intermediate,
    "scenarioType": ScenarioTypes.question,
    "descr":
        "You missed your flight and now need to request a refund from the airline. Learn how to ask the right questions to get it processed.",
    'aiRole':
        "Act as a customer service representative for an airline. You are polite but firm in explaining the refund process. Expect the first message to be the user's inquiry about the refund.",
    "tasks": [
      {
        "visibleTask": "Ask about the refund policy.",
        "hiddenTask":
            "User should ask 'What is the refund policy?' or something similar.",
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask for the steps to request a refund.",
        "hiddenTask": "User should ask 'How can I request a refund?'",
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask about the time it takes to receive a refund.",
        "hiddenTask":
            "User should ask 'How long will it take to process my refund?'",
        'answer': '',
        "type": "Inquiry"
      }
    ],
    "colors": [const Color(0xFFF7D8E9), const Color(0xFF562B63)],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Guess the Object in Your Bag",
    'time': 120,
    'firstMessage': "Let's start game! Are you ready to start?",
    "level": ChatDifficultLevels.beginner,
    "scenarioType": ScenarioTypes.charades,
    "descr":
        "You're playing a guessing game with your friend. You need to give them clues to help them guess an item in your bag.",
    'aiRole':
        "Act as a playful friend who loves guessing games. You are upbeat, enthusiastic, and ready to guess based on clues. You are playing with user in charades. Your task to provide description of words to the user. If user guess correctly move to next word. List of words ['dog', 'planet', 'sunlight']. Expect the first message from user to be an answer on question: 'Let's start game! Are you ready to start?'",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]. Important note: user's language level is newbie, use only easy phrases and words. Response in Korean language only.",
        'answer': '',
        "type": "Observation"
      }
    ],
    "colors": [customButtonColor, lightGreyTextColor],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/movie.png'
  },
  {
    "title": "Morning Coffee Date",
    'time': 500,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.observation,
    "level": ChatDifficultLevels.beginner,
    "descr":
        "You and your partner decided to go to a café. But your partner got lost in unknown area.",
    'aiRole':
        "Act as the user's partnter(girlfriend or boyfriend depends on user's gender). You are too much lovely, supportive, and very noisy. You and your partner decided to go to a café. You got lost and have no idea, where to go. You should ask user how cafe looks like. To do it user get a picture that could have following description: 'The image shows a picturesque, sunlit street lined with quaint buildings painted in warm shades of yellow and orange. Vibrant flowers in pots and hanging baskets adorn the balconies, and cozy outdoor cafés with wooden tables and chairs fill the sidewalk on both sides. Colorful awnings provide shade for the seating areas, and soft lighting from the hanging lamps adds to the inviting atmosphere. In the distance, hills rise up, completing the charming, peaceful European village ambiance.'. If the description they provide reaches around 60% accuracy (user's description can be considered as accurate if it close by meaning) in relation to the café scene, return, 'I get where to go!', if not keep asking user to tell more about this cafe based on image description until it won't get minimum percentage. Expect the first message from user to be an answer on question: 'Hi, darling, where are you? I cannot find the place' .Important note: user's language level is newbie, use only easy phrases and words.'",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": QuestionScenarioTypeOptions.response
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]. Important note: user's language level is newbie, use only easy phrases and words. Response in Korean language only.",
        'answer': '',
        "type": "Observation"
      }
    ],
    "colors": [Colors.lightBlueAccent, Colors.indigo],
    "circleColor": Colors.indigo.withOpacity(0.8),
    "imageIcon": 'assets/images/cafe1.png'
  },
  {
    "title": "Buying a Train Ticket",
    'time': 300,
    'firstMessage': "Hi, how can I help you with booking a train ticket today?",
    "level": ChatDifficultLevels.beginner,
    "scenarioType": ScenarioTypes.question,
    "descr":
        "You need to buy a train ticket and have several questions about schedules, availability, and prices.",
    'aiRole':
        "Act as a helpful ticket agent. You provide information about the train schedule, availability, and ticket prices. Expect the first question to be about the ticket booking process.",
    "tasks": [
      {
        "visibleTask": "Ask about the available train schedules for the day.",
        "hiddenTask":
            "The user needs to ask 'What time do the trains leave today?' or something similar. If matched, respond with train times and availability.",
        "answer": "",
        "type": QuestionScenarioTypeOptions.inquiry
      },
      {
        "visibleTask": "How much cost the ticket for the last train?",
        "hiddenTask":
            "The user needs to ask about the cost of a ticket. If matched, respond with ticket price details.",
        "answer": "180",
        "type": QuestionScenarioTypeOptions.response
      },
      {
        "visibleTask": "Ask if there are any available discounts.",
        "hiddenTask":
            "The user must ask for possible discounts. If matched, provide available discount options.",
        "answer": "",
        "type": QuestionScenarioTypeOptions.inquiry
      },
      {
        "visibleTask": "Ask about luggage allowances.",
        "hiddenTask":
            "The user must ask about bringing luggage. If matched, respond with luggage rules and limits.",
        "answer": "",
        "type": QuestionScenarioTypeOptions.inquiry
      }
    ],
    "colors": [const Color(0xFF918b05), const Color(0xFFeeebd7)],
    "circleColor": const Color(0xFFFCFF9E),
    "imageIcon": 'assets/images/train.png'
  },
  {
    "title": "Describing Your Apartment to a Roommate",
    'time': 300,
    'firstMessage':
        "Hey, can you tell me what your apartment looks like? I want to see if it's a good fit.",
    "scenarioType": ScenarioTypes.observation,
    "level": ChatDifficultLevels.beginner,
    "descr":
        "Your roommate is considering moving in and needs to know what your apartment looks like.",
    'aiRole':
        "Act as a potential roommate. You are interested in knowing what the apartment looks like and will ask follow-up questions if details are unclear. Expect the first message to be an answer to 'Can you describe your apartment?'.'",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]. Important note: user's language level is newbie, use only easy phrases and words. Response in Korean language only.",
        'answer': '',
        "type": "Observation"
      }
    ],
    "colors": [const Color(0xFFF7D8E9), const Color(0xFF562B63)],
    "circleColor": Colors.indigo.withOpacity(0.8),
    "imageIcon": 'assets/images/dorm_room.png'
  },
  {
    "title": "Scheduling a Doctor's Appointment with Receptionist",
    'time': 300,
    'firstMessage': 'Hi, darling, where are you? I cannot find the place.',
    "scenarioType": ScenarioTypes.question,
    "level": ChatDifficultLevels.beginner,
    "descr":
        "You need to schedule an appointment with your doctor. The clinic receptionist needs to check availability and confirm your details.",
    'aiRole':
        "Act as a clinic receptionist. You are polite, efficient, and slightly rushed due to a busy schedule.",
    "tasks": [
      {
        "visibleTask":
            "Ask your partner what coffee options are available at the café.",
        "hiddenTask":
            'User have to ask "Ask your partner what coffee options are available at the café.". If user question match fully or close it sense return [0]',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask your partner about their favorite type of coffee.",
        "hiddenTask":
            'User have to ask "Ask your partner about their favorite type of coffee."If user question match fully or close it sense response using the word "latte" in your answer.',
        'answer': 'latte',
        "type": "Response"
      },
      {
        "visibleTask": "Describe the layout of the café to your partner.",
        "hiddenTask":
            "User suppose to describe picture. On picture is shown 'layout of the café'. User have to mention 3 key elements from an image of the café: people, furniture, and lighting. If user mention only one of elements return question about other elements. If user call at least 2 elements return [2]",
        'answer': '',
        "type": "Observation"
      }
      // "Ask for available appointment slots next week.",
      // "Ask how long the appointment will last.",
      // "Confirm your phone number with the receptionist."
    ],
    "colors": [Colors.yellow, Colors.orange],
    "circleColor": Colors.orange.withOpacity(0.8),
    "imageIcon": 'assets/images/work.png'
  },
  {
    "title": "Checking into a Hotel for the First Time",
    'time': 300,
    "descr": "You're on your first solo trip and checking into a hotel.",
    "level": ChatDifficultLevels.newbie,
    "scenarioType": ScenarioTypes.question,
    'firstMessage': 'Hello. How could I help you?',
    "aiRole":
        "Act as a polite and professional hotel receptionist. You are friendly but formal, guiding the user through the check-in process smoothly.",
    "tasks": [
      {
        "visibleTask": "Ask the receptionist if they have your reservation.",
        "hiddenTask":
            "The user must ask, 'Do you have my reservation?' Return [0].",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask for details about your room (number, location).",
        "hiddenTask":
            "User should ask something like, 'Can you tell me about my room?'",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask what time breakfast is served.",
        "hiddenTask": "'What time is breakfast?'",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask if there’s Wi-Fi in the room.",
        "hiddenTask": "User asks, 'Is there Wi-Fi in my room?'",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask where you can find the nearest grocery store.",
        "hiddenTask": "User should ask about nearby shops or stores.",
        "type": "Inquiry",
        "answer": ""
      }
    ],
    "colors": [
      const Color(0xFF634a3a),
      const Color(0xFFac8250),
      const Color(0xFFe8c5ae)
    ],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/grocery.png'
  },
  {
    "title": "First Day in a Language Class",
    'time': 300,
    "descr":
        "You're attending your first-ever language class. You’ll be asked to introduce yourself, share your goals, and make a new friend. Make sure you remember the basic phrases!",
    "level": ChatDifficultLevels.newbie,
    "scenarioType": ScenarioTypes.question,
    'firstMessage': "Hello. You are new here? Let's get to know each other!",
    "aiRole":
        "Act as a kind and supportive classmate in a language class. You love meeting new people and helping them practice. Ask the user simple questions and encourage them to respond confidently.",
    "tasks": [
      {
        "visibleTask": "Introduce yourself to your classmate.",
        "hiddenTask":
            "The user should ask, 'My name is [name]. What’s yours?' If user asks similar, return [0].",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask your classmate where they are from.",
        "hiddenTask":
            "User must ask, 'Where are you from?' Return [1] if close match.",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask what they want to learn in the class.",
        "hiddenTask": "User should ask, 'What are you here to learn?'",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask if they’ve learned any languages before.",
        "hiddenTask":
            "User asks, 'Have you studied any languages before?' Return [2].",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Suggest practicing together after class.",
        "hiddenTask":
            "User should say something like, 'Do you want to practice after class?'",
        "type": "Inquiry",
        "answer": ""
      }
    ],
    "colors": [const Color(0xFFd1f0f7), const Color(0xFFf7d8d1)],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/grocery.png'
  },
  {
    "title": "Cleaning up a Messy Room",
    'time': 120,
    "descr":
        "You're helping to clean up a messy room with your friend. The room has several objects lying around, and you will help by describing the objects to figure out what to clean up next.",
    "level": ChatDifficultLevels.newbie,
    "scenarioType": ScenarioTypes.charades,
    'firstMessage': 'Why you roon in such mess? Clean it up!',
    "aiRole":
        "Act as a helpful friend who’s assisting with cleaning a messy room. Use simple language to describe an object in the room and guide the user to guess the object correctly.",
    "tasks": [
      {
        "visibleTask":
            "Look at the objects in the room. Ask your friend about the first thing you should pick up.",
        "hiddenTask":
            "The user should ask, 'What should I pick up first?' AI describes one object from the room picture.",
        "type": "Observation",
        "answer": ""
      },
      {
        "visibleTask":
            "Ask your friend if you should throw away the item or keep it.",
        "hiddenTask":
            "The user asks, 'Should I keep or throw it away?' AI gives a response based on the object.",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask":
            "Ask your friend where to put the item after cleaning it.",
        "hiddenTask":
            "User should ask, 'Where should I put this?' AI will suggest a spot for the item in the room.",
        "type": "Inquiry",
        "answer": ""
      }
    ],
    "colors": [
      const Color(0xFFfffce3),
      const Color(0xFFded488),
      const Color(0xFF7d6a2b)
    ],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/room.png'
  },
  {
    "title": "In the Zoo with Your Little Sister",
    'time': 120,
    "descr":
        "You're visiting the zoo with your little sister. She describe different animals, and you need to guess which animal it is.",
    "level": ChatDifficultLevels.newbie,
    "scenarioType": ScenarioTypes.charades,
    'firstMessage':
        "Hey. Do you want to play game? Please, play with, I'm bored!",
    "aiRole":
        "Act as the little sister who’s excited to guess animals based on the descriptions given by the user. Use simple and enthusiastic language, act as 6 years old, use appropriate to this age vocabulary. You are playing with user in charades. Your task to provide description of words to the user. If user guess correctly move to next word. List of animals consist of ['giraffe', 'elephant', 'tiger', 'lion', 'wolf', 'bear', 'turtle', 'horse', 'fox','monkey', 'crocodile']. Describe these animals in random order. If user correctly guess all animals create new list and continue game. Expect the first message from user to be an answer on question: 'Hey. Do you want to play game? Please, play with, I'm bored!'",
    "tasks": [
      {
        "visibleTask": "Describe the first animal your sister points to.",
        "hiddenTask":
            "AI describes an animal using simple words like 'It has stripes and is big.'",
        "type": "Observation",
        "answer": ""
      },
      {
        "visibleTask": "Ask your sister if she knows where this animal lives.",
        "hiddenTask":
            "User asks, 'Do you know where this animal lives?' AI responds with a fun fact about the animal's habitat.",
        "type": "Inquiry",
        "answer": ""
      },
      {
        "visibleTask": "Ask if your sister wants to see another animal.",
        "hiddenTask":
            "User should ask, 'Do you want to see more animals?' AI responds with excitement.",
        "type": "Inquiry",
        "answer": ""
      }
    ],
    "colors": [const Color(0xFFff4000), const Color(0xFFff8500)],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/zoo.jpg'
  },
  {
    "title": "Visiting Local Grocery Store in Village",
    'time': 300,
    'firstMessage': "Hey there! Please, come in. Do you need any help with?",
    "level": ChatDifficultLevels.newbie,
    "scenarioType": ScenarioTypes.question,
    "descr":
        "You’re visiting a small grocery store in a village and need help finding some basic items. ",
    'aiRole':
        "Act as a friendly store clerk in a small village grocery store. You’re patient and helpful, ready to assist the user with their questions about available items and their prices. Keep responses short and clear. Expect the first question to be the response on question 'Hey there! Please, come in. Do you need any help with?'.",
    "tasks": [
      {
        "visibleTask": "Ask if they have any fresh bread available.",
        "hiddenTask":
            'User has to ask "Do you have fresh bread?". If the question matches, respond with [0].',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask about the price of milk.",
        "hiddenTask":
            'User has to ask "What is the price of milk?". If the question matches fully or in a similar form, respond with [1].',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask if they can pack in bag.",
        "hiddenTask":
            'User has to ask "Do you sell locally grown vegetables?". If the question matches, return [2].',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask where the fruit section is located.",
        "hiddenTask":
            'User has to ask "Where is the fruit section?". If the question matches or is similar, respond with [3].',
        'answer': '',
        "type": "Inquiry"
      },
      {
        "visibleTask": "Ask if they sell bottled water.",
        "hiddenTask":
            'User has to ask "Do you sell bottled water?". If the question matches, respond with [4].',
        'answer': '',
        "type": "Inquiry"
      }
    ],
    "colors": [Colors.white, const Color.fromRGBO(149, 196, 229, 1)],
    "circleColor": lightGreyTextColor.withOpacity(0.8),
    "imageIcon": 'assets/images/grocery.png'
  },
];

enum QuestionScenarioTypeOptions { inquiry, response }

enum ScenarioTypes { question, observation, charades }

extension ScenarioTypesData on ScenarioTypes {
  IconData get icon {
    switch (this) {
      case ScenarioTypes.question:
        return Iconsax.message_question;
      case ScenarioTypes.observation:
        return Iconsax.image;
      case ScenarioTypes.charades:
        return FontAwesomeIcons.lightbulb;
    }
  }

  String get type {
    switch (this) {
      case ScenarioTypes.question:
        return "Inquiry";
      case ScenarioTypes.observation:
        return "Picture";
      case ScenarioTypes.charades:
        return "Charades";
    }
  }
}

enum ChatDifficultLevels { newbie, beginner, intermediate, advanced }

extension ChatDifficultLevelsData on ChatDifficultLevels {
  String get level {
    switch (this) {
      case ChatDifficultLevels.newbie:
        return "Newbie";
      case ChatDifficultLevels.beginner:
        return "Beginner";
      case ChatDifficultLevels.intermediate:
        return "Intermediate";
      case ChatDifficultLevels.advanced:
        return "Advanced";
    }
  }

  Color get color {
    switch (this) {
      case ChatDifficultLevels.newbie:
        return Colors.amberAccent;
      case ChatDifficultLevels.beginner:
        return customGreenColor;
      case ChatDifficultLevels.intermediate:
        return customButtonColor;
      case ChatDifficultLevels.advanced:
        return primaryPurpleColor;
    }
  }
}
