class StatesAndCities{
  static const  Map<String, List<String>> statesAndCities = {
    "All of Sri Lanka": [],
    "Colombo": [
      "Colombo", "Dehiwala-Mount Lavinia", "Moratuwa", "Sri Jayawardenepura Kotte", "Nugegoda", "Boralesgamuwa", "Maharagama",
      "Piliyandala", "Homagama", "Kolonnawa", "Kesbewa", "Ratmalana", "Battaramulla"
    ],
    "Gampaha": [
      "Gampaha", "Negombo", "Wattala", "Ja-Ela", "Kelaniya", "Ragama", "Seeduwa", "Kadawatha", "Biyagama", "Minuwangoda",
      "Divulapitiya", "Katunayake", "Mahara", "Attanagalla"
    ],
    "Kalutara": [
      "Kalutara", "Panadura", "Beruwala", "Horana", "Matugama", "Agalawatta", "Wadduwa", "Bulathsinhala", "Aluthgama", "Bandaragama",
      "Dodangoda"
    ],
    "Kandy": [
      "Kandy", "Peradeniya", "Katugastota", "Gampola", "Nawalapitiya", "Ampitiya", "Galaha", "Kundasale", "Wattegama", "Pilimatalawa",
      "Mawanella", "Udunuwara"
    ],
    "Matale": [
      "Matale", "Dambulla", "Sigiriya", "Ukuwela", "Rattota", "Nalanda", "Pallepola", "Yatawatta"
    ],
    "Nuwara Eliya": [
      "Nuwara Eliya", "Hatton", "Talawakele", "Ragala", "Walapane", "Nanu Oya", "Haputale", "Bandarawela"
    ],
    "Galle": [
      "Galle", "Hikkaduwa", "Ambalangoda", "Karapitiya", "Elpitiya", "Wakwella", "Bentota", "Balapitiya","Neluwa"
    ],
    "Matara": [
      "Matara", "Weligama", "Devinuwara", "Akuressa", "Deniyaya", "Kamburupitiya", "Hakmana"
    ],
    "Hambantota": [
      "Hambantota", "Tangalle", "Tissamaharama", "Ambalantota", "Kataragama", "Beliatta", "Ranna", "Sooriyawewa"
    ],
    "Jaffna": [
      "Jaffna", "Chavakachcheri", "Point Pedro", "Nallur", "Kopay", "Karainagar", "Valvettithurai"
    ],
    "Kilinochchi": [
      "Kilinochchi", "Paranthan", "Mulankavil", "Elephant Pass", "Tharmapuram", "Kandavalai"
    ],
    "Mannar": [
      "Mannar", "Pesalai", "Talaimannar", "Murunkan", "Madhu"
    ],
    "Vavuniya": [
      "Vavuniya", "Cheddikulam", "Nedunkeni", "Omanthai"
    ],
    "Mullaitivu": [
      "Mullaitivu", "Puthukkudiyiruppu", "Oddusuddan", "Mulliyawalai", "Thunukkai", "Kokilai"
    ],
    "Trincomalee": [
      "Trincomalee", "Kantale", "Kinniya", "Seruwila", "Mutur", "Nilaveli"
    ],
    "Batticaloa": [
      "Batticaloa", "Eravur", "Kaluwanchikudy", "Kattankudy", "Chenkalady", "Valaichchenai"
    ],
    "Ampara": [
      "Ampara", "Kalmunai", "Sainthamaruthu", "Akkaraipattu", "Sammanthurai", "Dehiattakandiya"
    ],
    "Anuradhapura": [
      "Anuradhapura", "Mihintale", "Kekirawa", "Galenbindunuwewa", "Medawachchiya", "Galnewa", "Padaviya", "Eppawala"
    ],
    "Polonnaruwa": [
      "Polonnaruwa", "Kaduruwela", "Hingurakgoda", "Thamankaduwa", "Medirigiriya"
    ],
    "Kurunegala": [
      "Kurunegala", "Kuliyapitiya", "Nikaweratiya", "Pannala", "Wariyapola", "Melsiripura", "Mawathagama"
    ],
    "Puttalam": [
      "Puttalam", "Chilaw", "Wennappuwa", "Marawila", "Kalpitiya", "Nattandiya", "Anamaduwa"
    ],
    "Kegalle": [
      "Kegalle", "Mawanella", "Rambukkana", "Warakapola", "Ruwanwella", "Galigamuwa", "Bulathkohupitiya"
    ],
    "Ratnapura": [
      "Ratnapura", "Balangoda", "Eheliyagoda", "Pelmadulla", "Kuruwita", "Nivithigala"
    ],
    "Moneragala": [
      "Moneragala", "Wellawaya", "Buttala", "Kataragama", "Siyambalanduwa", "Bibile"
    ],
    "Badulla": [
      "Badulla", "Bandarawela", "Ella", "Welimada", "Haputale", "Passara", "Hali Ela"
    ]
  };

  static List<String> getStates() {
    return statesAndCities.keys.toList();
  }

  static List<String> getCities(String state) {
    return statesAndCities[state] ?? [];
  }
}