# Job Tracker

This is a Ruby on Rails application for tracking job applications, interviews, and company contacts.

## Environment & Tooling
* **Devcontainer & Podman:** The development workflow uses a devcontainer, podman (not docker), and no VSCode. 
* **Command Execution:** Commands must be run inside the container (e.g. `podman exec job_tracker_rails-app_1 bin/rails ...` or `bundle exec rspec`). 

## Architecture & Conventions
* **RESTful Routing:** Avoid custom controller actions (no `member` or `collection` blocks). Treat actions as "hidden resources". For example, changing a job's status uses `Jobs::StatusAdvancementsController#create`, not `JobsController#advance_status`.
* **Fat Service Objects, Medium Models, Skinny Controllers:** Business logic (like state machines for job statuses) belongs in the Model (`Job#advance_status!`), not the controller.
* **Service Objects & OO Design:** Complex cross-model logic or external integrations use Service Objects (`JobCreationService`) and strict Object-Oriented patterns (e.g. `JobParsers::Base` with an auto-registering `self.inherited` hook and child parsers like `JobParsers::Greenhouse`).
* **Helpers:** View logic (determining CSS classes, conditionally showing buttons based on state) should be extracted to Helper modules (e.g., `JobsHelper`), keeping ERB views extremely clean.

## UI & Frontend
* **Turbo & Hotwire:** Heavy use of Turbo Frames and Turbo Streams for SPA-like responsiveness without writing JavaScript.
  * *Example:* Adding an `Activity` or `Contact` uses a `<turbo-frame>` for the form, and the controller responds with a `format.turbo_stream` payload to seamlessly update the feed and reset the form.
* **Styling:** Currently using Standard CSS stylesheets. Avoid inline styling. Looking to migrate to a framework shortly.

## Testing
* **RSpec:** Used for testing (not Minitest).
* **Testing Philosophy:** Tests should focus strictly on **Application Business Logic** (Services, Parsers, State Machines, Helpers, custom Turbo Stream request behaviors). Do NOT write tests for standard Rails functionality (e.g., basic ActiveRecord associations or built-in presence validations).

## Core Domain Models
1. **Company:** The parent model. Has many `Jobs` and `Contacts`.
2. **Job:** Belongs to `Company`. Tracks the state of the application using a strict "happy path" enum (`wishlist` -> `preparing` -> `applied` -> `interviewing` -> `offered`) or terminal states (`rejected`, `ghosted`, `withdrawn`). Has many `Activities`.
3. **Activity:** Belongs to `Job`. Tracks timeline events (emails, phone screens, interviews). Uses `action_type` enum.
4. **Contact:** Belongs to `Company`. Tracks people associated with the company (Recruiters, Engineers, Managers).
