import 'dart:convert';

MedicineIntakeModel modelFromJson(String str) => MedicineIntakeModel.fromJson(json.decode(str));

String modelToJson(MedicineIntakeModel data) => json.encode(data.toJson());

class MedicineIntakeModel {
    String ? medicineIntakeName;
    String ? dateTime;
    bool check;
    String ? repeat;
    int medicineIntakeId;
    int ? milliseconds;

    MedicineIntakeModel({
        required this.medicineIntakeName,
        required this.dateTime,
        required this.check,
        required this.repeat,
        required this.medicineIntakeId,
        required this.milliseconds
    });

    factory MedicineIntakeModel.fromJson(Map<String, dynamic> json) => MedicineIntakeModel(
        medicineIntakeName: json["medicineIntakeName"],
        dateTime: json["dateTime"],
        check: json["check"],
        repeat: json["repeat"],
        medicineIntakeId:json["medicineIntakeId"],
        milliseconds:json["milliseconds"],
    );

    Map<String, dynamic> toJson() => {
        "medicineIntakeName": medicineIntakeName,
        "dateTime": dateTime,
        "check": check,
        "repeat": repeat,
        "medicineIntakeId":medicineIntakeId,
        "milliseconds":milliseconds,
    };
}
