import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text("Privacy Policy",style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child: Html(
            data: '''<div style="text-align: justify;">
        <span>

        <h1>Privacy Policy of HomeHub for Online Home Service Booking Management</h1>

       <p>At HomeHub for Online Home Service Booking Management, one of our main priorities is the privacy of our visitors. This Privacy document contains types of information that is collected and recorded by HomeHub for Online Home Service Booking Management and how we use it.</p>

        <p>If you have additional questions or require more information about our Privacy, do not hesitate to contact us.</p>

        <h2>Log Files</h2>

        <p>HomeHub for Online Home Service Booking Management follows a standard procedure of using log files. These files log visitors when they visit apps. All hosting companies do this and a part of hosting services' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the app, tracking users' movement on the app, and gathering demographic information. Our Privacy was created with the help of the <a href="https://www.Privacyonline.com/privacy-policy-generator/">Privacy Generator</a>.</p>



        <h2>Our Advertising Partners</h2>

        <p>Some of advertisers on our app may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.</p>

        <ul>
        <li>
        <p>Google</p>
        <p><a href="https://policies.google.com/technologies/ads">https://policies.google.com/technologies/ads</a></p>
        </li>
        </ul>

        <h2>Privacy Policies</h2>

        <p>You may consult this list to find the Privacy for each of the advertising partners of HomeHub for Online Home Service Booking Management.</p>

        <p>Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on HomeHub for Online Home Service Booking Management, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on apps that you visit.</p>

        <p>Note that HomeHub for Online Home Service Booking Management has no access to or control over these cookies that are used by third-party advertisers.</p>

        <h2>Third Party Privacy Policies</h2>

        <p>HomeHub for Online Home Service Booking Management's Privacy does not apply to other advertisers or apps. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options. </p>

        <p>You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective apps. What Are Cookies?</p>

        <h2>Children's Information</h2>

        <p>Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.</p>

        <p>HomeHub for Online Home Service Booking Management does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our app, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.</p>

        <h2>Online Privacy Only</h2>

        <p>This Privacy applies only to our online activities and is valid for visitors to our app with regards to the information that they shared and/or collect in HomeHub for Online Home Service Booking Management. This policy is not applicable to any information collected offline or via channels other than this app.</p>

        <h2>Consent</h2>

        <p>By using our app, you hereby consent to our Privacy and agree to its Terms and Conditions.</p>
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
        ));
  }
}
