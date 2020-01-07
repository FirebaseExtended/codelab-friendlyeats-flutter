import 'dart:math';

final List<String> cities = <String>[
  'Albuquerque',
  'Arlington',
  'Atlanta',
  'Austin',
  'Baltimore',
  'Boston',
  'Charlotte',
  'Chicago',
  'Cleveland',
  'Colorado Springs',
  'Columbus',
  'Dallas',
  'Denver',
  'Detroit',
  'El Paso',
  'Fort Worth',
  'Fresno',
  'Houston',
  'Indianapolis',
  'Jacksonville',
  'Kansas City',
  'Las Vegas',
  'Long Island',
  'Los Angeles',
  'Louisville',
  'Memphis',
  'Mesa',
  'Miami',
  'Milwaukee',
  'Nashville',
  'New York',
  'Oakland',
  'Oklahoma',
  'Omaha',
  'Philadelphia',
  'Phoenix',
  'Portland',
  'Raleigh',
  'Sacramento',
  'San Antonio',
  'San Diego',
  'San Francisco',
  'San Jose',
  'Seattle',
  'Tucson',
  'Tulsa',
  'Virginia Beach',
  'Washington',
];

final List<String> categories = <String>[
  'Brunch',
  'Burgers',
  'Coffee',
  'Deli',
  'Dim Sum',
  'Indian',
  'Italian',
  'Mediterranean',
  'Mexican',
  'Pizza',
  'Ramen',
  'Sushi',
];

final List<String> _mockWords = <String>[
  'Bar',
  'Deli',
  'Diner',
  'Fire',
  'Grill',
  'Drive Thru',
  'Place',
  'Best',
  'Spot',
  'Trattoria',
  'Steakhouse',
  'Churrasco',
  'Tavern',
  'Cafe',
  'Pop-up',
  'Yummy',
  'Belly',
  'Snack',
  'Fast',
  'Turbo',
  'Hyper',
  'Prime',
  'Eatin\'',
];

final Map<int, List<String>> _mockReviewsData = <int, List<String>>{
  1: [
    'Would never eat here again!',
    'Such an awful place!',
    'Not sure if they had a bad day off, but the food was very bad.'
  ],
  2: [
    'Not my cup of tea.',
    'Unlikely that we will ever come again.',
    'Quite bad, but I\'ve had worse!'
  ],
  3: [
    'Exactly okay :/',
    'Unimpressed, but not disappointed!',
    '3 estrellas y van que arden.'
  ],
  4: [
    'Actually pretty good, would recommend!',
    'I really like this place, I come quite often!',
    'A great experience, as usual!'
  ],
  5: [
    'This is my favorite place. Literally',
    'This place is ALWAYS great!',
    'I recommend this to all my friends and family!'
  ],
};

final Random random = Random();

String getMockReview(int rating) {
  List reviews = _mockReviewsData[rating];
  return reviews[random.nextInt(reviews.length)];
}

String getMockName() {
  int firstWord = random.nextInt(_mockWords.length);
  int nextWord;
  do {
    nextWord = random.nextInt(_mockWords.length);
  } while (firstWord == nextWord);
  return '${_mockWords[firstWord]} ${_mockWords[nextWord]}';
}

String getRandomCategory() {
  return categories[random.nextInt(categories.length)];
}

String getRandomCity() {
  return cities[random.nextInt(cities.length)];
}

String getMockImageUrl() {
  int photoId = random.nextInt(21) + 1;
  return 'https://storage.googleapis.com/firestorequickstarts.appspot.com/food_$photoId.png';
}
