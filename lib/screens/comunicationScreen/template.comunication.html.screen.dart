import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/comunication.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/comunication.notifier.dart';
import 'package:provider/provider.dart';

class TemplateComunicationHtmlScreen extends StatelessWidget {
  const TemplateComunicationHtmlScreen({
    Key? key,
    required this.templateComunicationModel,
  }) : super(key: key);
  final TemplateComunicationModel templateComunicationModel;

  final String htmlcontent = """
 
	<html>
		 	<body style='width:100%;font-family:Poppins;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0'>
									<div class='es-wrapper-color'
   										lang='und'
   										style='background-color:#FFFFFF'>
										 
										<table class='es-wrapper'
     											width='100%'
     											cellspacing='0'
     											cellpadding='0'
     											role='none'
     											style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FFFFFF'>
											<tr style='border-collapse:collapse'>
												<td valign='top'
  													style='padding:0;Margin:0'>
													<table class='es-content'
     														cellspacing='0'
     														cellpadding='0'
     														align='center'
     														role='none'
     														style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%'>
														<tr style='border-collapse:collapse'>
															<td align='center'
  																bgcolor='#ffffff'
  																style='padding:0;Margin:0;background-color:#ffffff'>
																<table class='es-content-body'
     																	cellspacing='0'
     																	cellpadding='0'
     																	bgcolor='#ffffff'
     																	align='center'
     																	role='none'
     																	style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:680px'>
																	<tr style='border-collapse:collapse'>
																		<td align='left'
  																			style='padding:0;Margin:0'>
																			<table width='100%'
     																				cellspacing='0'
     																				cellpadding='0'
     																				role='none'
     																				style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																				<tr style='border-collapse:collapse'>
																					<td valign='top'
  																						align='center'
  																						style='padding:0;Margin:0;width:680px'>
																						<table width='100%'
     																							cellspacing='0'
     																							cellpadding='0'
     																							role='presentation'
     																							style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																							<tr style='border-collapse:collapse'>
																								<td align='center'
  																									style='padding:0;Margin:0;padding-top:30px;padding-bottom:30px;font-size:0px'>
																									<img src='https://www.give-newsletter.cloud/_attach/419/LogoFM_LQ.png'
   																										alt=''
   																										style='display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic'
   																										width='140'></td>
																								</tr>
																								<tr style='border-collapse:collapse'>
																									<td class='es-m-txt-r'
  																										align='left'
  																										style='padding:0;Margin:0;padding-bottom:10px;padding-right:15px;padding-left:20px'>
																										<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:30px;color:#a6cc38;font-size:20px'>
																											<em>
																												<strong>La tua Ricevuta</strong>
																											</em>
																										</p>
																									</td>
																								</tr>
																								<tr style='border-collapse:collapse'>
																									<td class='es-m-txt-l'
  																										align='left'
  																										style='padding:0;Margin:0;padding-left:20px;padding-right:20px;padding-bottom:40px'>
																										<a name='obesita'
 																											style='-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#333333;font-size:14px'/>
																										<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px'>
																											<strong>Grazie {{nome}}{{ragionesociale}},</strong>
																										</p>
																										<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px'>Abbiamo ricevuto la tua donazione di {{importo_donazioni}} euro che sta già sostenendo cure, assistenza e accoglienza per i bambini dell'ospedale pediatrico Meyer.</p>
																										<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px'>
																											<br></p>
																											<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px'>
																												<u>
																													<strong>In allegato trovi il nostro ringraziamento</strong>
																												</u> completo, con alcune informazioni su quanto anche tu hai contributo a fare oggi.<br>
																													<strong>
																														<u/>
																													</strong>
																													<br>Ti ricordiamo che le donazioni effettuate con mezzi tracciabili (bancomat, carta, assegno) sono deducibili dal proprio reddito secondo le norme vigenti.<br type='_moz'></p>
																														<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px'>
																															<br></p>
																															<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:poppins;line-height:25.5px;color:#333333;font-size:17px;text-align:right'>Ancora grazie!</p>
																														</td>
																													</tr>
																												</table>
																											</td>
																										</tr>
																									</table>
																								</td>
																							</tr>
																						</table>
																					</td>
																				</tr>
																			</table>
																			<table class='es-content'
     																				cellspacing='0'
     																				cellpadding='0'
     																				align='center'
     																				role='none'
     																				style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%'>
																				<tr style='border-collapse:collapse'>
																					<td align='center'
  																						style='padding:0;Margin:0'>
																						<table class='es-content-body'
     																							cellspacing='0'
     																							cellpadding='0'
     																							bgcolor='#ffffff'
     																							align='center'
     																							role='none'
     																							style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:680px'>
																							<tr style='border-collapse:collapse'>
																								<td align='left'
  																									bgcolor='#0b5394'
  																									style='padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;background-color:#0b5394'>
																									<table width='100%'
     																										cellspacing='0'
     																										cellpadding='0'
     																										role='none'
     																										style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																										<tr style='border-collapse:collapse'>
																											<td valign='top'
  																												align='center'
  																												style='padding:0;Margin:0;width:640px'>
																												<table width='100%'
     																													cellspacing='0'
     																													cellpadding='0'
     																													role='presentation'
     																													style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																													<tr style='border-collapse:collapse'>
																														<td align='center'
  																															class='es-m-txt-c es-m-p20'
  																															style='padding:0;Margin:0;padding-top:10px;padding-bottom:10px;font-size:0px;background-color:#0b5394'
  																															bgcolor='#0b5394'>
																															 
																																						</td>
																																					</tr>
																																				</table>
																																			</td>
																																		</tr>
																																	</table>
																																</td>
																															</tr>
																														</table>
																													</td>
																												</tr>
																											</table>
																											<table class='es-content'
     																												cellspacing='0'
     																												cellpadding='0'
     																												align='center'
     																												role='none'
     																												style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%'>
																												<tr style='border-collapse:collapse'>
																													<td align='center'
  																														style='padding:0;Margin:0'>
																														<table class='es-content-body'
     																															style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#ffffff;width:680px'
     																															cellspacing='0'
     																															cellpadding='0'
     																															bgcolor='#ffffff'
     																															align='center'
     																															role='none'>
																															<tr style='border-collapse:collapse'>
																																<td align='left'
  																																	style='padding:0;Margin:0'>
																																	<table width='100%'
     																																		cellspacing='0'
     																																		cellpadding='0'
     																																		role='none'
     																																		style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																																		<tr style='border-collapse:collapse'>
																																			<td valign='top'
  																																				align='center'
  																																				style='padding:0;Margin:0;width:680px'>
																																				<table width='100%'
     																																					cellspacing='0'
     																																					cellpadding='0'
     																																					role='presentation'
     																																					style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																																					<tr style='border-collapse:collapse'>
																																						<td align='center'
  																																							style='padding:0;Margin:0;padding-bottom:40px;padding-left:40px;padding-right:40px;font-size:0'
  																																							bgcolor='#0b5394'>
																																							<table width='100%'
     																																								height='100%'
     																																								cellspacing='0'
     																																								cellpadding='0'
     																																								border='0'
     																																								role='presentation'
     																																								style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																																								<tr style='border-collapse:collapse'>
																																									<td style='padding:0;Margin:0;border-bottom:0px solid #efefef;background:#00000000 none repeat scroll 0% 0%;height:1px;width:100%;margin:0px'/>
																																								</tr>
																																							</table>
																																						</td>
																																					</tr>
																																				</table>
																																			</td>
																																		</tr>
																																	</table>
																																</td>
																															</tr>
																														</table>
																													</td>
																												</tr>
																											</table>
																											<table class='es-footer'
     																												cellspacing='0'
     																												cellpadding='0'
     																												align='center'
     																												role='none'
     																												style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top'>
																												<tr style='border-collapse:collapse'>
																													<td align='center'
  																														style='padding:0;Margin:0'>
																														<table class='es-footer-body'
     																															cellspacing='0'
     																															cellpadding='0'
     																															align='center'
     																															role='none'
     																															style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#808080;width:680px'>
																															<tr style='border-collapse:collapse'>
																																<td align='left'
  																																	bgcolor='#0b5394'
  																																	style='Margin:0;padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px;background-color:#0b5394'>
																																	<table width='100%'
     																																		cellspacing='0'
     																																		cellpadding='0'
     																																		role='none'
     																																		style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																																		<tr style='border-collapse:collapse'>
																																			<td valign='top'
  																																				align='center'
  																																				style='padding:0;Margin:0;width:640px'>
																																				<table width='100%'
     																																					cellspacing='0'
     																																					cellpadding='0'
     																																					role='presentation'
     																																					style='mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px'>
																																					<tr style='border-collapse:collapse'>
																																						<td align='center'
  																																							bgcolor='#0b5394'
  																																							style='padding:0;Margin:0'>
																																							<strong/>
																																							<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:Poppins;line-height:21px;color:#FFFFFF;font-size:14px'>
																																								<strong>Fondazione dell'Ospedale Pediatrico Anna Meyer ETS</strong>
																																								<br>Iscritta nella sezione “ALTRI ENTI DEL TERZO SETTORE” del Registro unico nazionale del Terzo settore (rep. n. 117056; CF 94080470480),ai sensi dell’articolo 22 del D. Lgs. del 3 luglio&nbsp;2017 n. 117 e dell’articolo 17 del Decreto Ministeriale n. 106 del 15/09/2020</p>
																																								<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:Poppins;line-height:21px;color:#FFFFFF;font-size:14px'>
																																									<br></p>
																																								</td>
																																							</tr>
																																							<tr style='border-collapse:collapse'>
																																								<td align='center'
  																																									style='padding:0;Margin:0'>
																																									<p style='Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:Poppins;line-height:21px;color:#FFFFFF;font-size:14px'>Ricevi questa email perchè ci hai comunicato il tuo indirizzo email.<br></p>
																																									</td>
																																								</tr>
																																							</table>
																																						</td>
																																					</tr>
																																				</table>
																																			</td>
																																		</tr>
																																	</table>
																																</td>
																															</tr>
																														</table>
																													</td>
																												</tr>
																											</table>
																										</div>
																									</body>
																								</html>""";
  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        //drawer: const CustomDrawerWidget(),
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
              "Template comunicazione " + templateComunicationModel.name,
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        body: SingleChildScrollView(
          child: Consumer<ComunicationNotifier>(
            builder: (context, comunicationNotifier, _) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: comunicationNotifier.getEmailTemplateDetail(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idInstitution: cUserAppInstitutionModel
                          .idInstitutionNavigation.idInstitution,
                      idtemplate: templateComunicationModel.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      color: Colors.redAccent,
                                    ))),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'No data...',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    } else {
                      TemplateDetailComunicationModel tSnapshot =
                          snapshot.data as TemplateDetailComunicationModel;
                      return SingleChildScrollView(
                          child: Text(tSnapshot.html_body));
                    }
                  },
                ),
              );
            },
          ),
        ));
  }
}
