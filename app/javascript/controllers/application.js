import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete'
import RailsNestedForm from '@stimulus-components/rails-nested-form'

const application = Application.start()
application.register('autocomplete', Autocomplete)
application.register('nested-form', RailsNestedForm)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

import { Slideover } from "tailwindcss-stimulus-components"
application.register('slideover', Slideover)
