import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String description;
  final String cancelButtonText;
  final String okButtonText;
  final VoidCallback onCancel;
  final VoidCallback onOk;
  final bool isWarning;
  final bool isDelete;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.cancelButtonText,
    required this.okButtonText,
    required this.onCancel,
    required this.onOk,
    required this.isWarning,
    required this.isDelete,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isWarning
              ? const Icon(
                  Icons.warning,
                  color: Colors.amber,
                  size: 50,
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: !widget.isWarning? 30 : 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              !widget.isWarning? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isDelete ? Colors.transparent : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: widget.isDelete? Border.all(color: Colors.black) : null
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          widget.isDelete ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: widget.onCancel,
                    child: Text(widget.cancelButtonText),
                  ),
                ),
              ) : const SizedBox(),
              SizedBox(
                width: !widget.isWarning? 5 : 0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isDelete ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: widget.onOk,
                    child: Text(widget.okButtonText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
