# Specification

When a user clicks on a row in the Words table, the user should navigate to the Word Detail screen.

The Word Detail screen contains the following fields in a vertical column:

Spanish word - text field

English definition - text field

Part of speech - dropdown

Date and Time - not editable

Note or Reference - large text field to add any notes or reference information

At the bottom, there should be two buttons:

Primary button - Update word - the button senses any changes in the Word Detail fields and activates if there are changes.

Secondary button - Delete word - this button, when clicked, should have a popup modal that warns about deletion being permanent.

# Delete Word in Firestore

When delete is confirmed, the document ID for the word should be referenced and sent via Firestore API to delete the word in the collection.

# Issues

1. When I update the Spanish or English text in the Word Detail screen, the update is not saved in the database.  FIXED.

2. When I add a note in the Word Detail Screen, the note is not saved in the database.  FIXED.