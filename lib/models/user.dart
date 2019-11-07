class User {
  const User(this.latitude, this.longitude, this.image, this.name);

  User.fromRandomUserResponse(Map<String, dynamic> json)
      : latitude = double.tryParse(
                json['results'][0]['location']['coordinates']['latitude']) ??
            0,
        longitude = double.tryParse(
                json['results'][0]['location']['coordinates']['longitude']) ??
            0,
        name =
            '${json['results'][0]['name']['first']} ${json['results'][0]['name']['last']}',
        image = json['results'][0]['picture']['large'];

  final double latitude;
  final double longitude;
  final String image;
  final String name;
}
