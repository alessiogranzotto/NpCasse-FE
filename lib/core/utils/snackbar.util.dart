import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackUtil {
  static stylishSnackBar(
      {required String title,
      required String message,
      required String contentType}) {
    // return SnackBar(
    //   backgroundColor: Colors.blue[100],
    //   // behavior: SnackBarBehavior.floating,
    //   // margin: const EdgeInsets.all(40),

    //   dismissDirection: DismissDirection.up,
    //   behavior: SnackBarBehavior.floating,
    //   margin: const EdgeInsets.all(50),
    //   elevation: 30,
    //   // margin: EdgeInsets.only(
    //   //     bottom: MediaQuery.of(context).size.height - 150,
    //   //     left: 10,
    //   //     right: 10),
    //   content: Text(
    //     text,
    //     style: Theme.of(context).textTheme.headlineMedium,
    //   ),
    // );
    // return SnackBar(
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   elevation: 0,
    //   content: Stack(children: [
    //     Container(
    //         padding: const EdgeInsets.all(16),
    //         height: 90,
    //         decoration: const BoxDecoration(
    //           color: Colors.black12,
    //           borderRadius: BorderRadius.all(Radius.circular(20)),
    //         ),
    //         child: const Row(
    //           children: [
    //             SizedBox(
    //               width: 48,
    //               child: Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       'Oh snap',
    //                       style: TextStyle(color: Colors.white, fontSize: 12),
    //                       maxLines: 2,
    //                       overflow: TextOverflow.ellipsis,
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )),
    //   ]),
    // );
    return SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
          title: title,
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: contentType == "failure"
              ? ContentType.failure
              : (contentType == "help"
                  ? ContentType.help
                  : (contentType == "success"
                      ? ContentType.success
                      : ContentType.warning))),
    );
  }
}
