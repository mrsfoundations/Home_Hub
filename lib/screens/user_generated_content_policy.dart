import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class UGC extends StatefulWidget {
  const UGC({Key? key}) : super(key: key);

  @override
  _UGCState createState() => _UGCState();
}

class _UGCState extends State<UGC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text("User Generated Content",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: '''<div style="text-align: justify;">
<span style="">
 
  
<h2><strong>User Generated Content policy</strong></h2>

<p>Welcome to HomeHub for Online Home Service Booking Management!</p>

<p>Welcome to our HomeHub Online Home Service Booking Management app! We're excited to have you as part of our community. Here's our User Generated Content policy:</p>

<h3><strong>1.Prohibited content:</strong></h3>

<p>Any content that promotes illegal activity, discrimination, or harmful behavior towards animals or other users is strictly prohibited.</p>

<h3><strong>2.Moderation guidelines:</strong></h3>

<p>Our team will review all user-generated content to ensure it complies with our policy. We reserve the right to remove any content that violates our policy, and repeat offenders may be banned from the app.</p>

<h3><strong>3.User responsibilities:</strong></h3>

<p>You are responsible for ensuring that any content you submit to the app is accurate and does not infringe on the rights of others. You must also comply with all applicable laws and regulations.</p>

<h3><strong>4.Copyright and ownership:</strong></h3>

<p>You retain ownership of any content you submit to the app. However, by submitting content, you grant us a non-exclusive, royalty-free license to use, copy, modify, and distribute the content as we see fit.</p>

<h3><strong>5.User privacy:</strong></h3>

<p>We respect your privacy and will only collect personal information necessary to provide our services. We will not share your information with third parties without your consent.</p>

<h3><strong>6.Disclaimers and liability:</strong></h3>

<p>We are not responsible for the accuracy or reliability of user-generated content. By using the app, you agree to hold us harmless from any damages resulting from the use or misuse of user-generated content.</p>

<h3><strong>7.Amendments:</strong></h3>

<p>We may update our User Generated Content policy from time to time. We will notify you of any changes and your continued use of the app after the changes have been made constitutes your acceptance of the updated policy.</p>

<p>Thank you for being a part of our HomeHub Online Home Service Booking Management app community!</p>
</span>
 <br><br>
Contact of publishers and Developers<br>
Narasimman<br>
42,Om Sakthi Nagar<br>
Chennai Main Rd<br>
Villupuram district<br>
Pincode :605602<br>
Cell:9790055058<br>
Mailid:narasimman2k@gmail.com<br>  
</div>


        </div>
    </div>''',
        ),
      ),
    );
  }
}
