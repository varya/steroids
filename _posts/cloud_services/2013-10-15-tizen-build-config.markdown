---
layout: post
title:  "Tizen Build Configuratíon"
date:   2013-05-21 13:51:34
categories: cloud_services
platforms: Tizen
---

###Related guides
- [Installing Tizen apps][installing-tizen-apps-guide]
- [Local development with Tizen][tizen-local-development-guide]

The Tizen build configuration page is very simple, since all Tizen properties are configured via the `www/config.tizen.xml` file. See the [Tizen Web App preferences guide][config-xml-tizen-guide] for more information.

## Certificate

The only thing you need to set up is the `.p12` certificate. You should use the [Tizen SDK](https://developer.tizen.org/downloads/sdk/installing-tizen-sdk) certificate generator at `~/tizen-sdk/tools/certificate-generator/certificate-generator.sh` (or wherever your Tizen SDK is installed) to generate a `.p12` file.

Run the `certificate-generator.sh` script. You will be asked a bunch of optional questions, and finally a password, alias and file name for your certificate. Enter something you'll remember – you'll input it to the Tizen build configuration page in a moment.

After you're done, the Terminal window will output the location of your `.p12` certificate file.

In the [AppGyver Build Service](http://cloud.appgyver.com/applications), go to your application (remember to deploy it to the cloud with `$ steroids deploy`), open the **Configure Tizen Build Settings** page, upload your `.p12` file and enter the password. Save the changes, and click **Build an Ad Hoc Build**. The `.wgt` file will be available for download soon.

For installing your app on a device, see the [Installing Tizen apps guide][installing-tizen-apps-guide].

For local development with Steroids on Tizen, see the [Tizen local development guide][tizen-local-development-guide].
[tizen-local-development-guide]: /steroids/guides/tizen/local-development/
[installing-tizen-apps-guide]: /steroids/guides/tizen/installing-apps/
[config-xml-tizen-guide]: /steroids/guides/tizen/config-xml-tizen/

