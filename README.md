Redmine Plus Automation
===================================

Redmine Plus Automation Community is a plugin for Redmine that enhances automation capabilities within the Redmine project management system. It provides additional features and tools to streamline workflows, automate repetitive tasks, and improve overall productivity for teams using Redmine.

<img src="automation-plugin.png" width="800"/>

== Features
* Advanced workflow automation
* Customizable triggers, actions and conditions
* User-friendly interface for managing automation rules
* Support for Redmine 5.x and later versions
* Regular updates and community support

Free vs Pro Comparison
-----------------------

| Feature Category | Community (Free) | Pro Version |
|------------------|------------------|--------------|
| **Triggers** | • Issue CRUD<br>• Issue Comments CRUD | • Issue CRUD<br>• Issue Comments CRUD<br>• Issue Moved<br>• Issue Transitioned<br>• Manual from Issue<br>• Spent Time<br>• Scheduled |
| **Actions** | • Clone Issue<br>• Comment on Issue<br>• Create Issue<br>• Create Sub-task<br>• Delete Attachments<br>• Delete Issue<br>• Edit Comment<br>• Edit Issue | • Assign Issue<br>• Clone Issue<br>• Comment on Issue<br>• Create Issue<br>• Create Sub-task<br>• Delete Attachments<br>• Delete Issue<br>• Delete Issue Links<br>• Edit Comment<br>• Edit Issue<br>• Link Issues<br>• Log Work<br>• Manage Watchers<br>• Send Email<br>• Send Web Request<br>• Log Action |
| **Branches for Related Issues** | • Parent Issue<br>• Current Issue | • Parent Issue<br>• Current Issue<br>• Sub-tasks<br>• Linked Issue<br>• Created Issue |
| **Advanced Redmine Query Language** | ❌ | ✅ Enables complex filtering and triggering options |
| **Support & Updates** | Community-based | Priority support and continuous updates |

👉 **Get the full Pro version here:** [Redmine Automation Pro](https://redmineplus.com/redmine-automation/)


Demo
-----
Try the live demo of full Redmine Plus Automation plugin [here](https://redmineplus.com/sign-up-to-redmine-plus/).

Installation
------------
To install the Redmine Plus Automation Community plugin, follow these steps:

1. Download the plugin from the repository.
2. Extract the plugin files to the `plugins` directory of your Redmine installation.
3. Run the following commands in your Redmine root directory:
   ```
   bundle install
   rake redmine:plugins:migrate RAILS_ENV=production
   ```
4. Restart your Redmine server.

For more detailed installation instructions, please refer to the [official documentation](https://redmineplus.com/how-to-install-redmine-automation-plugin/).

Usage
-----
To start using the Redmine Plus Automation Community plugin, follow these steps:
1. Navigate to the "Administration" section in Redmine.
2. Click on "Automation" menu to access the plugin settings.
3. Configure the automation rules according to your requirements.
4. Save the settings and start using the automation features.

For detailed documentation and tutorials, please refer to the [official documentation](https://redmineplus.com/docs/introduction).

Contributing
----------------
We welcome contributions from the community! If you would like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with clear messages.
4. Push your changes to your forked repository.
5. Submit a pull request to the main repository.

License
-------
This plugin is licensed under the GNU General Public License v3.0. See the LICENSE file for more details.

Support
-------
For support and questions, please visit the [Redmine Plus Automation Community forum](https://www.redmine.org/projects/redmine-plus-automation) or open an issue on the GitHub repository.

Acknowledgements
----------------
We would like to thank all contributors and users who have helped improve this plugin and make it a valuable tool for the Redmine community.
