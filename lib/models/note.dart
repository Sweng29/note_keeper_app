class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  int get id => _id;

  String get description => _description;

  String get title => _title;

  String get date => _date;

  int get priority => _priority;

  set title(String title) {
    if (title != null) this._title = title;
  }

  set description(String description) {
    this._description = description;
  }

  set date(String date) {
    this._date = date;
  }

  set priority(int priority) {
    if (priority >= 1 && priority <= 2) {
      this._priority = priority;
    }
  }

  // Convert a Note object into Map object
  Map<String, dynamic> topMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
  }
}
