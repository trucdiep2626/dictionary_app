import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/utils/app_utils.dart';
import 'package:dictionary_app/common/utils/layout_extension.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:dictionary_app/presentations/widgets/app_button.dart';
import 'package:flutter/material.dart';

Future showAppDialog(BuildContext context, String messageText,
    {Widget? messageWidget,
    String? iconPath,
    bool isIconSvg = false,
    bool customBody = false,
    bool checkTimeout = true,
    Widget? widgetBody,
    required String confirmButtonText,
    Color confirmButtonColor = Colors.white,
    VoidCallback? confirmButtonCallback,
    String? cancelButtonText,
    Color cancelButtonColor = Colors.white,
    VoidCallback? cancelButtonCallback,
    bool dismissAble = false,
    WidgetBuilder? builder,
    bool? delayConfirm,
    TextAlign? messageTextAlign}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissAble,
    builder: builder ??
        (BuildContext context) => AppDialog(
              checkTimeout: checkTimeout,
              delayConfirm: delayConfirm,
              message: messageText,
              messageWidget: messageWidget,
              iconPath: iconPath,
              isIconSvg: isIconSvg,
              customBody: customBody,
              widgetBody: widgetBody,
              confirmButtonText: confirmButtonText,
              confirmButtonColor: confirmButtonColor,
              confirmButtonCallback: confirmButtonCallback,
              cancelButtonText: cancelButtonText,
              cancelButtonCallback: cancelButtonCallback,
              messageTextAlign: TextAlign.start,
            ),
  );
}

class AppDialog extends StatefulWidget with LayoutExtension {
  final String message;
  final Widget? messageWidget;
  final String? iconPath;
  final bool isIconSvg;
  final bool customBody;
  final bool dismissAble;
  final Widget? widgetBody;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final VoidCallback? confirmButtonCallback;
  final String? cancelButtonText;
  final Color? cancelButtonColor;
  final VoidCallback? cancelButtonCallback;
  final bool? delayConfirm;
  final TextAlign messageTextAlign;
  final bool checkTimeout;

  const AppDialog(
      {Key? key,
      required this.message,
      this.messageWidget,
      this.iconPath,
      this.isIconSvg = false,
      this.customBody = false,
      this.dismissAble = false,
      this.widgetBody,
      required this.confirmButtonText,
      required this.confirmButtonColor,
      this.confirmButtonCallback,
      this.cancelButtonText,
      this.cancelButtonColor,
      this.cancelButtonCallback,
      required this.messageTextAlign,
      this.checkTimeout = true,
      this.delayConfirm = false})
      : super(key: key);

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> with LayoutExtension {
  bool enableConfirm = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.dismissAble,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              12,
            ),
            color: Colors.white,
          ),
          width: screenWidth - 2 * 16,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  textAlign: widget.messageTextAlign,
                  style: ThemeText.bodySemibold.s16,
                ),
                widget.messageWidget ?? const SizedBox.shrink(),
                const SizedBox(height: 16),
                Visibility(
                  visible: enableConfirm,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: AppButton(
                          isOutlineButton: true,
                          titleFontSize: 14,
                          title: widget.cancelButtonText ?? 'Cancel',
                          backgroundColor: Colors.transparent,
                          onPressed: widget.cancelButtonCallback ??
                              () => NavigationService.goBack(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          title: widget.confirmButtonText,
                          titleFontSize: 14,
                          onPressed: widget.confirmButtonCallback,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!isNullEmpty(widget.delayConfirm)) {
      setState(() {
        enableConfirm = false;
      });
      Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {
            enableConfirm = true;
          }));
    }
  }
}
