import 'organization.dart';

class Task {
  final String id;
  final String titulo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<OrganizationUser> usuarios;
  /**
   * Pueden ser 'To do', 'In Progress' y 'Done'
   */
  String status;

  Task({
    required this.id,
    required this.titulo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.usuarios,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final String id = (json['_id'] ?? json['id'] ?? '')
        .toString(); // ??? Ese agente de AI deberia haber tenido en cuenta el backend.
    final String titulo =
        (json['titulo'] ??
                json['title'] ??
                'Sin título') // ? si solamente tenemos un backend...
            .toString();
    String status = (json['status'] ?? 'To do'); // Por defecto To do

    return Task(
      id: id,
      titulo: titulo,
      fechaInicio: _parseDate(json['fechaInicio'] ?? json['fecha_inicio']),
      fechaFin: _parseDate(json['fechaFin'] ?? json['fecha_fin']),
      usuarios:
          (json['usuarios'] as List<dynamic>?)
              ?.map((dynamic u) => OrganizationUser.fromJson(u))
              .toList() ??
          [],
      status: status,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException('Fecha inválida en Task: $value');
  }
}
