steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class s3upload extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "s3upload"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "s3upload.html"),
    ]

    @copyFile path.join("www", "s3upload.html"), "s3upload.html.template"

    Help.SUCCESS()
    console.log """

    S3 upload example generated successfully! The following file was created:

      - www/s3upload.html

    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "s3upload.html"

    For this example, you need to create a bucket to Amazon S3 with eased-off CORS rules like:

    <CORSConfiguration>
     <CORSRule>
       <AllowedOrigin>*</AllowedOrigin>
       <AllowedMethod>GET</AllowedMethod>
       <AllowedMethod>PUT</AllowedMethod>
       <AllowedMethod>POST</AllowedMethod>
       <AllowedMethod>DELETE</AllowedMethod>
       <AllowedHeader>*</AllowedHeader>
     </CORSRule>
    </CORSConfiguration>

    And give access to 'everyone' with at least upload/delete permission to make this work.

    Also configure your bucket name in www/s3upload.html.


    """

module.exports = s3upload
