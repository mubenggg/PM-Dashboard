SELECT ALLFILES.*, ACTIVEFILES.*

FROM

(SELECT          
						 A.batchno AS BATCHNO, 
						 CASE WHEN B.id IS NOT NULL OR tblPayment.payment > 0 THEN 'CTC' ELSE 'UTC' END AS CTC_STATUS, 
						 CASE WHEN tblTPSRE.debtorid IS NOT NULL THEN 1 ELSE 0 END AS TPS_E, 
						 CASE WHEN tbl0A19.debtorId IS NOT NULL THEN 1 ELSE 0 END AS TPS_0A19, 
						 CASE WHEN tbl0A14.debtorId IS NOT NULL THEN 1 ELSE 0 END AS TPS_0A14, 
						 CASE WHEN tbl0A15.debtorId IS NOT NULL THEN 1 ELSE 0 END AS TPS_0A15, 
                         ISNULL(GTR.GtrContactCount_E, 0) AS #GTR_E, 
						 ISNULL(GTR.CTC, 0) AS #GTR_E_CTC, 
						 A.statuscode AS STATUS_CODE, 
						 A.statusGroup AS STATUS_GROUP, 
						 CASE WHEN tblContactNumber.id IS NULL THEN 0 ELSE tblContactNumber.totalNumber END AS #CONTACT_NO, 



						 CASE WHEN totalFollowup.debtorid IS NOT NULL THEN totalFollowup.totalFollowup ELSE 0 END AS #FOLLOW_UP, 
                         CASE WHEN totalFollowup.totalFollowupMTH1 IS NOT NULL THEN totalFollowup.totalFollowupMTH1 ELSE 0 END AS #FOLLOW_UP_MTH1,
						 CASE WHEN totalFollowup.totalFollowupMTH2Today IS NOT NULL THEN totalFollowup.totalFollowupMTH2Today ELSE 0 END AS #FOLLOW_UP_MTH2_TODAY,
						 CASE WHEN totalFollowup.totalFollowupMTH2 IS NOT NULL THEN totalFollowup.totalFollowupMTH2 ELSE 0 END AS #FOLLOW_UP_MTH2,
						 CASE WHEN totalFollowup.totalFollowupMTH3Today IS NOT NULL THEN totalFollowup.totalFollowupMTH3Today ELSE 0 END AS #FOLLOW_UP_MTH3_TODAY,
						 CASE WHEN totalFollowup.totalFollowupMTH3 IS NOT NULL THEN totalFollowup.totalFollowupMTH3 ELSE 0 END AS #FOLLOW_UP_MTH3, 
						 CASE WHEN totalFollowup.totalFollowupMTH4Today IS NOT NULL THEN totalFollowup.totalFollowupMTH4Today ELSE 0 END AS #FOLLOW_UP_MTH4_TODAY,
						 CASE WHEN totalFollowup.totalFollowupMTH4 IS NOT NULL THEN totalFollowup.totalFollowupMTH4 ELSE 0 END AS #FOLLOW_UP_MTH4, 
						 DATEDIFF(day, tblLastFollowup.followupdate, GETDATE()) AS CALLING_GAP, 
						 tblLastFollowup.followupdate AS LAST_FOLLOWUP,
                          

						 A.balance AS BALANCE, 
						 CASE WHEN A.totalPayment > 0 THEN A.TotalPayment ELSE 0 END AS TTL_PAID,
						 CASE WHEN isnull(A.totalPayment, 0) + isnull(A.ClaimPaidAmnt, 0) > 0 THEN 1 ELSE 0 END AS PMT_ACC, 
						 ISNULL(tblLastPaid.paidDate, '') AS LAST_PAID_DT, 
						 CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidAmnt ELSE 0 END AS CP,
						 CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidDt END AS CP_DT, 
						 CASE WHEN A.flagPTP = 1 THEN A.ptpAmount ELSE 0 END AS PTP,
						 CASE WHEN A.FlagPTP = 1 THEN A.nextpay END AS PTP_DT, 
						 A.id AS DEBTOR_ID,
						 A.memo AS Memo, 
						 A.newic AS NRIC, 
						 A.Gtr1_IC, A.Gtr2_IC, 
						 tblLastFollowup.telNo AS CONTACT_NO, 
                         A.LatestRemark AS LAST_REMARK, 
						 tblContact.state AS STATE, 
						 tblContact.city AS CITY, 
						 A.occupation AS OCCUPATION, 
						 tablelod.First_LOD, 
						 tablelod.LOD_Status_Count

FROM            (SELECT        Client_200.name as ClientName, dbo.ClientReporting.clientReportName1, dbo.ClientReporting.clientReportName, dbo.ClientReporting.pmName, dbo.Debtor.batchno, dbo.Debtor.account, dbo.Debtor.cardno, dbo.Debtor.balance, dbo.Debtor.totalPayment, dbo.Debtor.id, 
                                                    dbo.Debtor.accountType, dbo.Debtor.aging, dbo.Debtor.receivedDate, dbo.Debtor.termination, dbo.Debtor.NewExpiryDate, dbo.Debtor.lastPayAmount, dbo.Debtor.lastPayDate, dbo.Collector.name AS collectorName, 
                                                    dbo.Debtor.statuscode, dbo.Debtor.memo, dbo.Debtor.newic, dbo.Debtor.flagPTP, dbo.Debtor.nextpay, dbo.Debtor.ptpAmount, dbo.Debtor.flagClaimPaid, dbo.Debtor.ClaimPaidAmnt, dbo.Debtor.ClaimPaidDt, 
                                                    dbo.Debtor.producttype, dbo.Debtor.LatestRemark, dbo.Status.statusGroup, dbo.Debtor.occupation, dbo.Debtor.Batch1Refno AS Gtr1_IC, dbo.Debtor.Batch2Refno AS Gtr2_IC
                          FROM            dbo.Debtor WITH (NOLOCK) INNER JOIN
                                                    dbo.ClientReporting WITH (NOLOCK) ON dbo.Debtor.clientId = dbo.ClientReporting.clientId INNER JOIN
                                                    dbo.Collector WITH (NOLOCK) ON dbo.Debtor.collectorid = dbo.Collector.id INNER JOIN
													dbo.Client as Client_200 WITH (NOLOCK) ON dbo.Debtor.clientid = Client_200.id INNER JOIN
                                                    dbo.Status WITH (NOLOCK) ON dbo.Debtor.statuscode = dbo.Status.code
                          WHERE        (dbo.ClientReporting.pmName = 'NIZAM') AND (dbo.Debtor.flagAbort = 0)) AS A 
						  

						  LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_21.id, COUNT(dbo.ContactNumber.ContactNo) AS GtrContactCount_E, CASE WHEN ContactNumber.FlagContactable = 1 THEN 1 ELSE 0 END AS CTC
                               FROM            dbo.Debtor AS Debtor_21 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo WITH (NOLOCK) ON Debtor_21.id = dbo.Debtor_ContactNo.debtorid INNER JOIN
                                                         dbo.ContactNumber WITH (NOLOCK) ON dbo.Debtor_ContactNo.contactNoId = dbo.ContactNumber.Id INNER JOIN
                                                         dbo.Client WITH (NOLOCK) ON Debtor_21.clientId = dbo.Client.id INNER JOIN
                                                         dbo.TPS WITH (NOLOCK) ON dbo.ContactNumber.Sourceid = dbo.TPS.ID INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_21 WITH (NOLOCK) ON Debtor_21.clientId = ClientReporting_21.clientId
                               WHERE        (ClientReporting_21.pmName = 'NIZAM') AND (Debtor_21.flagAbort = 0) AND (dbo.ContactNumber.Type = 'Guarantor') AND (dbo.TPS.tpsr = 'TPSR (E)')
                               GROUP BY Debtor_21.id, dbo.ContactNumber.FlagContactable, Debtor_21.account) AS GTR ON A.id = GTR.id 
							   

							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_20.id
                               FROM            dbo.Debtor AS Debtor_20 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo AS Debtor_ContactNo_5 WITH (NOLOCK) ON Debtor_20.id = Debtor_ContactNo_5.debtorid INNER JOIN
                                                         dbo.ContactNumber AS ContactNumber_5 WITH (NOLOCK) ON Debtor_ContactNo_5.contactNoId = ContactNumber_5.Id INNER JOIN
                                                         dbo.Client AS Client_3 WITH (NOLOCK) ON Debtor_20.clientId = Client_3.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_20 WITH (NOLOCK) ON Debtor_20.clientId = ClientReporting_20.clientId
                               WHERE        (ClientReporting_20.pmName = 'NIZAM') AND (Debtor_20.flagAbort = 0) AND (ContactNumber_5.FlagContactable = 1)) AS B ON A.id = B.id 
							   

							   LEFT OUTER JOIN


                             (SELECT        MAX(dbo.Payment.paymentdate) AS paidDate, Debtor_1.id
                               FROM            dbo.Debtor AS Debtor_1 INNER JOIN
                                                         dbo.Payment ON Debtor_1.id = dbo.Payment.debtorid INNER JOIN
                                                         dbo.Client AS Client_1 ON Debtor_1.clientId = Client_1.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_19 ON Debtor_1.clientId = ClientReporting_19.clientId
                               WHERE        (ClientReporting_19.pmName = 'NIZAM')
                               GROUP BY Debtor_1.id) AS tblLastPaid ON A.id = tblLastPaid.id 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_19.id, dbo.Contact.state, dbo.Contact.city, dbo.Debtor_Contact.flagSelected, Debtor_19.account
                               FROM            dbo.Debtor AS Debtor_19 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_Contact WITH (NOLOCK) ON Debtor_19.id = dbo.Debtor_Contact.debtorid INNER JOIN
                                                         dbo.Contact WITH (NOLOCK) ON dbo.Debtor_Contact.contactid = dbo.Contact.id INNER JOIN
                                                         dbo.Client AS Client_19 WITH (NOLOCK) ON Debtor_19.clientId = Client_19.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_18 WITH (NOLOCK) ON Debtor_19.clientId = ClientReporting_18.clientId
                               WHERE        (ClientReporting_18.pmName = 'NIZAM') AND (Debtor_19.flagAbort = 0) AND (dbo.Debtor_Contact.flagSelected = 1) AND (LEN(dbo.Contact.state) > 1)) AS tblContact ON A.id = tblContact.id 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT        Payment_6.debtorid, Payment_6.payment, Payment_6.paymentdate
                               FROM            dbo.Payment AS Payment_6 WITH (NOLOCK) INNER JOIN
                                                             (SELECT        MAX(Payment_5.id) AS paymentId, Debtor_18.id AS debtorId
                                                               FROM            dbo.Payment AS Payment_5 WITH (NOLOCK) INNER JOIN
                                                                                         dbo.Debtor AS Debtor_18 WITH (NOLOCK) ON Payment_5.debtorid = Debtor_18.id INNER JOIN
                                                                                         dbo.Client AS Client_18 WITH (NOLOCK) ON Debtor_18.clientId = Client_18.id INNER JOIN
                                                                                         dbo.ClientReporting AS ClientReporting_17 WITH (NOLOCK) ON Debtor_18.clientId = ClientReporting_17.clientId
                                                               WHERE        (ClientReporting_17.pmName = 'NIZAM') AND (Debtor_18.flagAbort = 0)
                                                               GROUP BY Debtor_18.id) AS tblPayment1 ON Payment_6.id = tblPayment1.paymentId) AS tblPayment ON A.id = tblPayment.debtorid
															   
															   
															   LEFT OUTER JOIN


                             (SELECT        dbo.Followup.followupdate, dbo.Followup.debtorid, dbo.Followup.telNo
                               FROM            dbo.Followup WITH (NOLOCK) INNER JOIN
                                                             (SELECT        MAX(Followup_5.followupdate) AS FollowupDate, Followup_5.debtorid
                                                               FROM            dbo.Debtor AS Debtor_17 WITH (NOLOCK) INNER JOIN
                                                                                         dbo.Followup AS Followup_5 WITH (NOLOCK) ON Debtor_17.id = Followup_5.debtorid INNER JOIN
                                                                                         dbo.Client AS Client_17 WITH (NOLOCK) ON Debtor_17.clientId = Client_17.id INNER JOIN
                                                                                         dbo.ClientReporting AS ClientReporting_16 WITH (NOLOCK) ON Debtor_17.clientId = ClientReporting_16.clientId
                                                               WHERE        (ClientReporting_16.pmName = 'NIZAM') AND (Followup_5.callduration > 0) AND (Debtor_17.flagAbort = 0)
                                                               GROUP BY Followup_5.debtorid) AS tblLastFollowup2 ON dbo.Followup.followupdate = tblLastFollowup2.FollowupDate AND dbo.Followup.debtorid = tblLastFollowup2.debtorid) AS tblLastFollowup ON 
                         A.id = tblLastFollowup.debtorid 
						 
						 
						 LEFT OUTER JOIN


                             (SELECT DISTINCT Followup_4.debtorid
                               FROM            dbo.Debtor AS Debtor_16 WITH (NOLOCK) INNER JOIN
                                                         dbo.Followup AS Followup_4 WITH (NOLOCK) ON Debtor_16.id = Followup_4.debtorid INNER JOIN
                                                         dbo.Client AS Client_16 WITH (NOLOCK) ON Debtor_16.clientId = Client_16.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_15 WITH (NOLOCK) ON Debtor_16.clientId = ClientReporting_15.clientId
                               WHERE        (ClientReporting_15.pmName = 'NIZAM') AND (Followup_4.status IN ('ABORT BKR', 'ABORT BR', 'ABORT DEC', 'ABORT UTC', 'ABORT')) AND (Debtor_16.flagAbort = 0)) AS tblAbort ON 
                         A.id = tblAbort.debtorid
						 
						 
						 LEFT OUTER JOIN


                             (SELECT DISTINCT Followup_3.debtorid
                               FROM            dbo.Debtor AS Debtor_15 WITH (NOLOCK) INNER JOIN
                                                         dbo.Followup AS Followup_3 WITH (NOLOCK) ON Debtor_15.id = Followup_3.debtorid INNER JOIN
                                                         dbo.Client AS Client_15 WITH (NOLOCK) ON Debtor_15.clientId = Client_15.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_14 WITH (NOLOCK) ON Debtor_15.clientId = ClientReporting_14.clientId
                               WHERE        (ClientReporting_14.pmName = 'NIZAM') AND (Followup_3.status IN ('TPSR (E)','TPSR (B)')) AND (Debtor_15.flagAbort = 0)) AS tblTPSRE ON A.id = tblTPSRE.debtorid 
							   
							   
							   LEFT OUTER JOIN
                             
							 
							 (SELECT        debtorid, 
							 COUNT(totalFollowup) AS totalFollowup, COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(GETDATE()) AND YEAR(totalFollowup) = YEAR(GETDATE()) THEN totalFollowup END) AS totalFollowupMTH1,
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, -1, GETDATE())) AND DAY(totalFollowup) <= DAY(GETDATE()) THEN totalFollowup END) AS totalFollowupMTH2Today,
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, - 1, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, - 1, GETDATE())) THEN totalFollowup END) AS totalFollowupMTH2, 
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, -2, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, -2, GETDATE())) AND DAY(totalFollowup) <= DAY(GETDATE()) THEN totalFollowup END) AS totalFollowupMTH3Today,
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, - 2, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, - 2, GETDATE())) THEN totalFollowup END) AS totalFollowupMTH3, 
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, -3, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, -3, GETDATE())) AND DAY(totalFollowup) <= DAY(GETDATE()) THEN totalFollowup END) AS totalFollowupMTH4Today,
							 COUNT(CASE WHEN MONTH(totalFollowup) = MONTH(DATEADD(MONTH, - 3, GETDATE())) AND YEAR(totalFollowup) = YEAR(DATEADD(MONTH, - 3, GETDATE())) THEN totalFollowup END) AS totalFollowupMTH4
                               FROM            (SELECT DISTINCT CAST(Followup_2.followupdate AS date) AS totalFollowup, Followup_2.debtorid
                                                         FROM            dbo.Debtor AS Debtor_14 WITH (NOLOCK) INNER JOIN
                                                                                   dbo.Followup AS Followup_2 WITH (NOLOCK) ON Debtor_14.id = Followup_2.debtorid INNER JOIN
                                                                                   dbo.Client AS Client_14 WITH (NOLOCK) ON Debtor_14.clientId = Client_14.id INNER JOIN
                                                                                   dbo.ClientReporting AS ClientReporting_13 WITH (NOLOCK) ON Debtor_14.clientId = ClientReporting_13.clientId
                                                         WHERE        (ClientReporting_13.pmName = 'NIZAM') AND (Followup_2.callduration > 0) AND (Debtor_14.flagAbort = 0)) AS tblFL
                               GROUP BY debtorid) AS totalFollowup ON A.id = totalFollowup.debtorid 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Followup_1.debtorid
                               FROM            dbo.Debtor AS Debtor_13 WITH (NOLOCK) INNER JOIN
                                                         dbo.Followup AS Followup_1 WITH (NOLOCK) ON Debtor_13.id = Followup_1.debtorid INNER JOIN
                                                         dbo.Client AS Client_13 WITH (NOLOCK) ON Debtor_13.clientId = Client_13.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_12 WITH (NOLOCK) ON Debtor_13.clientId = ClientReporting_12.clientId
                               WHERE        (ClientReporting_12.pmName = 'NIZAM') AND (Followup_1.status IN ('FV RE')) AND (Debtor_13.flagAbort = 0)) AS tblVisit ON A.id = tblVisit.debtorid 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_12.id, COUNT(ContactNumber_4.Id) AS totalNumber
                               FROM            dbo.Debtor AS Debtor_12 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo AS Debtor_ContactNo_4 WITH (NOLOCK) ON Debtor_12.id = Debtor_ContactNo_4.debtorid INNER JOIN
                                                         dbo.ContactNumber AS ContactNumber_4 WITH (NOLOCK) ON Debtor_ContactNo_4.contactNoId = ContactNumber_4.Id INNER JOIN
                                                         dbo.Client AS Client_12 WITH (NOLOCK) ON Debtor_12.clientId = Client_12.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_11 WITH (NOLOCK) ON Debtor_12.clientId = ClientReporting_11.clientId
                               WHERE        (ClientReporting_11.pmName = 'NIZAM') AND (Debtor_12.flagAbort = 0)
                               GROUP BY Debtor_12.id) AS tblContactNumber ON A.id = tblContactNumber.id 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_11.id AS debtorId
                               FROM            dbo.Debtor AS Debtor_11 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo AS Debtor_ContactNo_3 WITH (NOLOCK) ON Debtor_11.id = Debtor_ContactNo_3.debtorid INNER JOIN
                                                         dbo.ContactNumber AS ContactNumber_3 WITH (NOLOCK) ON Debtor_ContactNo_3.contactNoId = ContactNumber_3.Id INNER JOIN
                                                         dbo.Client AS Client_11 WITH (NOLOCK) ON Debtor_11.clientId = Client_11.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_10 WITH (NOLOCK) ON Debtor_11.clientId = ClientReporting_10.clientId
                               WHERE        (ClientReporting_10.pmName = 'NIZAM') AND (ContactNumber_3.Sourceid = 307) AND (Debtor_11.flagAbort = 0)
                               GROUP BY Debtor_11.id) AS tbl0A19 ON A.id = tbl0A19.debtorId 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_10.id AS debtorId
                               FROM            dbo.Debtor AS Debtor_10 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo AS Debtor_ContactNo_2 WITH (NOLOCK) ON Debtor_10.id = Debtor_ContactNo_2.debtorid INNER JOIN
                                                         dbo.ContactNumber AS ContactNumber_2 WITH (NOLOCK) ON Debtor_ContactNo_2.contactNoId = ContactNumber_2.Id INNER JOIN
                                                         dbo.Client AS Client_10 WITH (NOLOCK) ON Debtor_10.clientId = Client_10.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_9 WITH (NOLOCK) ON Debtor_10.clientId = ClientReporting_9.clientId
                               WHERE        (ClientReporting_9.pmName = 'NIZAM') AND (ContactNumber_2.Sourceid = 254) AND (Debtor_10.flagAbort = 0)
                               GROUP BY Debtor_10.id) AS tbl0A15 ON A.id = tbl0A15.debtorId 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT DISTINCT Debtor_9.id AS debtorId
                               FROM            dbo.Debtor AS Debtor_9 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor_ContactNo AS Debtor_ContactNo_1 WITH (NOLOCK) ON Debtor_9.id = Debtor_ContactNo_1.debtorid INNER JOIN
                                                         dbo.ContactNumber AS ContactNumber_1 WITH (NOLOCK) ON Debtor_ContactNo_1.contactNoId = ContactNumber_1.Id INNER JOIN
                                                         dbo.Client AS Client_9 WITH (NOLOCK) ON Debtor_9.clientId = Client_9.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_8 WITH (NOLOCK) ON Debtor_9.clientId = ClientReporting_8.clientId
                               WHERE        (ClientReporting_8.pmName = 'NIZAM') AND (ContactNumber_1.Sourceid = 266) AND (Debtor_9.flagAbort = 0)
                               GROUP BY Debtor_9.id) AS tbl0A14 ON A.id = tbl0A14.debtorId 
							   
							   
							  LEFT OUTER JOIN


                             (SELECT        debtor_40.id, COUNT(CASE WHEN followup_40.status = 'LOD_S' THEN 1 END) AS LOD_Status_Count, MIN(CASE WHEN followup_40.status = 'LOD_S' THEN CAST(followup_40.followupdate AS DATE) END) 
                                                         AS First_LOD
                               FROM            dbo.Debtor AS debtor_40 WITH (NOLOCK) INNER JOIN
                                                         dbo.Followup AS followup_40 WITH (NOLOCK) ON debtor_40.id = followup_40.debtorid INNER JOIN
                                                         dbo.Client AS client_40 WITH (NOLOCK) ON debtor_40.clientId = client_40.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_1 WITH (NOLOCK) ON debtor_40.clientId = ClientReporting_1.clientId
                               WHERE        (ClientReporting_1.pmName = 'NIZAM') AND (debtor_40.flagAbort = 0)
                               GROUP BY debtor_40.id) AS tablelod ON tablelod.id = A.id) 
							   
							   AS ACTIVEFILES
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


							   FULL OUTER JOIN


							   (
							   SELECT 
							   A.id AS DEBTOR_ID_ALL, 
							   A.flagabort, 
							   A.collectorname as CRO, 
							   A.clientname AS ClientName, 
							   A.clientreportname AS PRODUCT, 
							   A.clientreportname1 AS ProductGroup, 
							   A.account AS ACC_NO, 
							   A.cardno as CARD_NO,
							   tblMtdPayment.totalPaid AS MTH_1, 
						 tblPrevMthPayment.totalPaidAsOfToday AS MTH_2_today,
						 tblPrevMthPayment.totalPaid AS MTH_2,
                         tblLast2MthPayment.totalPaidAsOfToday AS MTH_3_today,
						 tblLast2MthPayment.totalPaid AS MTH_3,
						 tblLast3MthPayment.totalPaidAsOfToday AS MTH_4_today, 
						 tblLast3MthPayment.totalPaid AS MTH_4,		
						 CASE WHEN tblMtdPayment.totalPaid > 0 AND ((A.totalPayment + (CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidAmnt ELSE 0 END)) - ISNULL(tblMtdPayment.totalpaid, 0) = 0) THEN 'NEW' ELSE '0' END AS NEW_PMT_MTH1, 
						 CASE WHEN tblPrevMthPayment.totalPaid > 0 AND ((A.totalPayment + (CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidAmnt ELSE 0 END)) - (ISNULL(tblMtdPayment.totalPaid, 0) + ISNULL(tblPrevMthPayment.totalPaid, 0)) = 0) THEN 'NEW' ELSE '0' END AS NEW_PMT_MTH2, 
						 CASE WHEN tblLast2MthPayment.totalPaid > 0 AND ((A.totalPayment + (CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidAmnt ELSE 0 END)) - (ISNULL(tblMtdPayment.totalPaid, 0) + ISNULL(tblPrevMthPayment.totalPaid, 0) + ISNULL(tblLast2MthPayment.totalPaid, 0)) = 0) THEN 'NEW' ELSE '0' END AS NEW_PMT_MTH3, 
						 CASE WHEN tblLast3MthPayment.totalPaid > 0 AND ((A.totalPayment + (CASE WHEN A.flagClaimPaid = 1 AND A.ClaimPaidDt >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) THEN A.ClaimPaidAmnt ELSE 0 END)) - (ISNULL(tblMtdPayment.totalPaid, 0) + ISNULL(tblPrevMthPayment.totalPaid, 0) + ISNULL(tblLast2MthPayment.totalPaid, 0) + ISNULL(tblLast3MthPayment.totalPaid, 0)) = 0) THEN 'NEW' ELSE '0' END AS NEW_PMT_MTH4 

							   
							   FROM
							   
							   
							   (SELECT        Debtor.flagabort, Client_300.name as ClientName, dbo.ClientReporting.clientReportName1, dbo.ClientReporting.clientReportName, dbo.ClientReporting.pmName, dbo.Debtor.batchno, dbo.Debtor.account, dbo.Debtor.cardno, dbo.Debtor.balance, dbo.Debtor.totalPayment, dbo.Debtor.id, 
                                                    dbo.Debtor.accountType, dbo.Debtor.aging, dbo.Debtor.receivedDate, dbo.Debtor.termination, dbo.Debtor.NewExpiryDate, dbo.Debtor.lastPayAmount, dbo.Debtor.lastPayDate, dbo.Collector.name AS collectorName, 
                                                    dbo.Debtor.statuscode, dbo.Debtor.memo, dbo.Debtor.newic, dbo.Debtor.flagPTP, dbo.Debtor.nextpay, dbo.Debtor.ptpAmount, dbo.Debtor.flagClaimPaid, dbo.Debtor.ClaimPaidAmnt, dbo.Debtor.ClaimPaidDt, 
                                                    dbo.Debtor.producttype, dbo.Debtor.LatestRemark, dbo.Status.statusGroup, dbo.Debtor.occupation, dbo.Debtor.Batch1Refno AS Gtr1_IC, dbo.Debtor.Batch2Refno AS Gtr2_IC
                          FROM            dbo.Debtor WITH (NOLOCK) INNER JOIN
                                                    dbo.ClientReporting WITH (NOLOCK) ON dbo.Debtor.clientId = dbo.ClientReporting.clientId INNER JOIN
                                                    dbo.Collector WITH (NOLOCK) ON dbo.Debtor.collectorid = dbo.Collector.id INNER JOIN
													dbo.Client as Client_300 WITH (NOLOCK) ON dbo.Debtor.clientid = Client_300.id INNER JOIN
                                                    dbo.Status WITH (NOLOCK) ON dbo.Debtor.statuscode = dbo.Status.code
                          WHERE        (dbo.ClientReporting.pmName = 'NIZAM')) AS A


						  LEFT OUTER JOIN


                             (SELECT        Payment_4.debtorid, COALESCE (SUM(Payment_4.payment), 0) AS totalPaid
                               FROM            dbo.Payment AS Payment_4 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor AS Debtor_8 WITH (NOLOCK) ON Payment_4.debtorid = Debtor_8.id INNER JOIN
                                                         dbo.Client AS Client_8 WITH (NOLOCK) ON Debtor_8.clientId = Client_8.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_7 WITH (NOLOCK) ON Debtor_8.clientId = ClientReporting_7.clientId
                               WHERE        (ClientReporting_7.pmName = 'NIZAM') AND (Payment_4.confirmed = 'Y') AND (CAST(Payment_4.paymentdate AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AND 
                                                         (CAST(Payment_4.paymentdate AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
                               GROUP BY Payment_4.debtorid
                               UNION
                               SELECT        Debtor_7.id, COALESCE (SUM(Debtor_7.ClaimPaidAmnt), 0) AS totalPaid
                               FROM            dbo.Debtor AS Debtor_7 WITH (NOLOCK) INNER JOIN
                                                        dbo.Client AS Client_7 WITH (NOLOCK) ON Debtor_7.clientId = Client_7.id INNER JOIN
                                                        dbo.ClientReporting AS ClientReporting_6 WITH (NOLOCK) ON Debtor_7.clientId = ClientReporting_6.clientId
                               WHERE        (ClientReporting_6.pmName = 'NIZAM') AND (Debtor_7.flagClaimPaid = 1) AND (CAST(Debtor_7.ClaimPaidDt AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AND 
                                                        (CAST(Debtor_7.ClaimPaidDt AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
                               GROUP BY Debtor_7.id) AS tblMtdPayment ON A.id = tblMtdPayment.debtorid 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT        Payment_3.debtorid, COALESCE (SUM(Payment_3.payment), 0) AS totalPaid,
							 COALESCE(SUM(CASE WHEN DAY(Payment_3.paymentdate) <= DAY(GETDATE()) THEN Payment_3.payment ELSE 0 END), 0) AS totalPaidAsOfToday
                               FROM            dbo.Payment AS Payment_3 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor AS Debtor_6 WITH (NOLOCK) ON Payment_3.debtorid = Debtor_6.id INNER JOIN
                                                         dbo.Client AS Client_6 WITH (NOLOCK) ON Debtor_6.clientId = Client_6.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_5 WITH (NOLOCK) ON Debtor_6.clientId = ClientReporting_5.clientId
                               WHERE        (ClientReporting_5.pmName = 'NIZAM') AND (Payment_3.confirmed = 'Y') AND (CAST(Payment_3.paymentdate AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0)) AND 
                                                         (CAST(Payment_3.paymentdate AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))
                               GROUP BY Payment_3.debtorid
                               UNION
                               SELECT        Debtor_5.id, COALESCE (SUM(Debtor_5.ClaimPaidAmnt), 0) AS totalPaid,
							   COALESCE(SUM(CASE WHEN DAY(Debtor_5.ClaimPaidDt) <= DAY(GETDATE()) THEN Debtor_5.ClaimPaidAmnt ELSE 0 END), 0) AS totalPaidAsOfToday
                               FROM            dbo.Debtor AS Debtor_5 WITH (NOLOCK) INNER JOIN
                                                        dbo.Client AS Client_5 WITH (NOLOCK) ON Debtor_5.clientId = Client_5.id INNER JOIN
                                                        dbo.ClientReporting AS ClientReporting_4 WITH (NOLOCK) ON Debtor_5.clientId = ClientReporting_4.clientId
                               WHERE        (ClientReporting_4.pmName = 'NIZAM') AND (Debtor_5.flagClaimPaid = 1) 
							   AND (CAST(Debtor_5.ClaimPaidDt AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0)) AND 
                                                        (CAST(Debtor_5.ClaimPaidDt AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))
                               GROUP BY Debtor_5.id) AS tblPrevMthPayment ON A.id = tblPrevMthPayment.debtorid 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT        Payment_2.debtorid, COALESCE (SUM(Payment_2.payment), 0) AS totalPaid,
							 COALESCE(SUM(CASE WHEN DAY(Payment_2.paymentdate) <= DAY(GETDATE()) THEN Payment_2.payment ELSE 0 END), 0) AS totalPaidAsOfToday
                               FROM            dbo.Payment AS Payment_2 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor AS Debtor_4 WITH (NOLOCK) ON Payment_2.debtorid = Debtor_4.id INNER JOIN
                                                         dbo.Client AS Client_4 WITH (NOLOCK) ON Debtor_4.clientId = Client_4.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_3 WITH (NOLOCK) ON Debtor_4.clientId = ClientReporting_3.clientId
                               WHERE        (ClientReporting_3.pmName = 'NIZAM') AND (Payment_2.confirmed = 'Y') AND (CAST(Payment_2.paymentdate AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 2, 0)) AND 
                                                         (CAST(Payment_2.paymentdate AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0))
                               GROUP BY Payment_2.debtorid) AS tblLast2MthPayment ON A.id = tblLast2MthPayment.debtorid 
							   
							   
							   LEFT OUTER JOIN


                             (SELECT        Payment_1.debtorid, COALESCE (SUM(Payment_1.payment), 0) AS totalPaid,
							 COALESCE(SUM(CASE WHEN DAY(Payment_1.paymentdate) <= DAY(GETDATE()) THEN Payment_1.payment ELSE 0 END), 0) AS totalPaidAsOfToday
                               FROM            dbo.Payment AS Payment_1 WITH (NOLOCK) INNER JOIN
                                                         dbo.Debtor AS Debtor_2 WITH (NOLOCK) ON Payment_1.debtorid = Debtor_2.id INNER JOIN
                                                         dbo.Client AS Client_2 WITH (NOLOCK) ON Debtor_2.clientId = Client_2.id INNER JOIN
                                                         dbo.ClientReporting AS ClientReporting_2 WITH (NOLOCK) ON Debtor_2.clientId = ClientReporting_2.clientId
                               WHERE        (ClientReporting_2.pmName = 'NIZAM') AND (Payment_1.confirmed = 'Y') AND (CAST(Payment_1.paymentdate AS date) >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 3, 0)) AND 
                                                         (CAST(Payment_1.paymentdate AS date) < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 2, 0))
                               GROUP BY Payment_1.debtorid) AS tblLast3MthPayment ON A.id = tblLast3MthPayment.debtorid


						  
						  ) AS ALLFILES ON ACTIVEFILES.DEBTOR_ID = ALLFILES.DEBTOR_ID_ALL

						  WHERE flagabort = 0 
						   
						   OR (flagabort = 1 AND 
							   (MTH_1 IS NOT NULL OR 
								MTH_2 IS NOT NULL OR 
								MTH_3 IS NOT NULL OR 
								MTH_4 IS NOT NULL))