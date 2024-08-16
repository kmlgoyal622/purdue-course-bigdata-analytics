from google.cloud import storage
import pandas as pd

def flatten_json_files(request):
    """
    Cloud Function triggered by HTTP request. Flattens all JSON files in ml_assess_2 bucket to CSV.
    """
    storage_client = storage.Client()
    bucket = storage_client.bucket("ml_assess_2")
    
    # List all JSON files in the bucket
    blobs = bucket.list_blobs(prefix="opensky_data_")  # Filter by filename prefix
    

    for blob in blobs:
        try:
            # Download JSON file
            json_string = blob.download_as_string()
            data = json.loads(json_string)

            # Flatten JSON to DataFrame
            df = pd.json_normalize(data.get("states", []))  # Extract and flatten 'states' data
            
            # Ensure consistent column naming (in case the number of columns change between downloads)
            df.columns = [f"col_{i}" for i in range(len(df.columns))] 
            
            # Add timestamp column (extracting from filename)
            timestamp = blob.name.split("_")[2].split(".")[0]  # Extract timestamp from filename
            df.insert(0, "timestamp", timestamp) 

            # Convert DataFrame to CSV
            csv_data = df.to_csv(index=False)

            # Create new CSV file name
            csv_filename = blob.name.replace(".json", ".csv")
            print(f"Attempting to upload CSV: {csv_filename}")

            # Upload CSV file
            csv_blob = bucket.blob(csv_filename)
            csv_blob.upload_from_string(csv_data, content_type="text/csv")

            print(f"Flattened JSON file: {blob.name} to CSV: {csv_filename}")

        except Exception as e:
            print(f"Error processing file {blob.name}: {e}")

    return "JSON to CSV conversion completed."
