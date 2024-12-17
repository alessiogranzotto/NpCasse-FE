class StateModel {
  final dynamic id;
  final String name;

  StateModel({required this.id, required this.name});

  // Factory constructor to create a StateModel from a JSON map
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] as dynamic,
      name: json['name'] as String,
    );
  }

  // Method to convert a StateModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Optional: Factory method for an empty state (e.g., for handling null or fallback)
  factory StateModel.empty() {
    return StateModel(id: 0, name: 'None');
  }

  @override
  String toString() => name;
}
