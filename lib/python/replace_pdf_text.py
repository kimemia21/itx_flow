import os
import tempfile
import traceback
import json
from flask import Flask, request, send_file, jsonify
from pdfrw import PdfReader, PdfWriter
from PyPDF2 import PdfReader as PyPDF2Reader, PdfWriter as PyPDF2Writer
from flask_cors import CORS  # Add CORS support

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

def replace_form_fields(input_pdf_path, replacements):
    """Replace text in PDF form fields using pdfrw."""
    reader = PdfReader(input_pdf_path)
    edited = False

    for page in reader.pages:
        for annotation in page.Annots or []:
            if annotation.get('/Subtype') == '/Widget':
                field_name = annotation.get('/T', '').strip('"')
                if field_name in replacements:
                    annotation.update({
                        '/V': replacements[field_name]
                    })
                    edited = True

    return reader, edited

def replace_text_content(input_pdf_path, replacements):
    """Replace text content in PDF using PyPDF2."""
    reader = PyPDF2Reader(input_pdf_path)
    writer = PyPDF2Writer()
    edited = False

    for page_num in range(len(reader.pages)):
        page = reader.pages[page_num]
        text = page.extract_text()
        
        needs_replacement = any(old_text in text for old_text in replacements.keys())
        
        if needs_replacement:
            edited = True
            for old_text, new_text in replacements.items():
                text = text.replace(old_text, new_text)
                
        writer.add_page(page)

    return writer, edited

@app.route('/replace_text', methods=['POST'])
def replace_text():
    try:
        # Step 1: Get the uploaded PDF file
        if 'pdf' not in request.files:
            return jsonify({"error": "No PDF file uploaded"}), 400
        
        file = request.files['pdf']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        # Step 2: Get replacements from form data
        try:
            replacements_str = request.form.get('replacements')
            if replacements_str:
                replacements = json.loads(replacements_str)
            else:
                replacements = {
                    '[Name of Seller]': 'John Doe',
                    '[Name of Buyer]': 'Jane Smith',
                    '[Contract Date]': '2023-12-01'
                }
        except json.JSONDecodeError:
            return jsonify({"error": "Invalid replacements JSON"}), 400

        # Step 3: Save the uploaded file temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix='.pdf') as temp_input:
            input_pdf_path = temp_input.name
            file.save(input_pdf_path)

        # Try form field replacement first
        reader, form_edited = replace_form_fields(input_pdf_path, replacements)
        
        if form_edited:
            # Save the form-edited PDF
            output_pdf_path = tempfile.mktemp(suffix='.pdf')
            writer = PdfWriter()
            writer.write(output_pdf_path, reader)
        else:
            # If no form fields were edited, try content replacement
            writer, content_edited = replace_text_content(input_pdf_path, replacements)
            
            if not content_edited:
                return jsonify({"error": "No matching text found for replacement"}), 400
            
            # Save the content-edited PDF
            output_pdf_path = tempfile.mktemp(suffix='.pdf')
            with open(output_pdf_path, 'wb') as output_file:
                writer.write(output_file)

        # Send the modified PDF file as response
        return send_file(
            output_pdf_path,
            as_attachment=True,
            download_name="edited_document.pdf",
            mimetype='application/pdf'
        )

    except Exception as e:
        tb_str = traceback.format_exc()
        return jsonify({"error": str(e), "traceback": tb_str}), 500

    finally:
        # Cleanup temporary files
        try:
            if 'input_pdf_path' in locals():
                os.remove(input_pdf_path)
            if 'output_pdf_path' in locals():
                os.remove(output_pdf_path)
        except Exception:
            pass

if __name__ == '__main__':
    app.run(port=8002, debug=True)