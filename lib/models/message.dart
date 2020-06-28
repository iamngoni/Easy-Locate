class StatusMessage{
  String message;
  StatusMessage({this.message});
  factory StatusMessage.fromJson(Map<String, dynamic> json){
    return StatusMessage(message: json['message']);
  }
}