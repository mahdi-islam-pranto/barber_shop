-- Run this in the Supabase SQL editor

-- Allow authenticated users to upload files
CREATE POLICY "Allow authenticated users to upload files"
ON storage.objects
FOR INSERT
TO authenticated
USING (bucket_id = 'shopimages');

-- Allow authenticated users to update their own files
CREATE POLICY "Allow authenticated users to update their own files"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'shopimages' AND (auth.uid())::text = (storage.foldername(name))[1]);

-- Allow public to view files
CREATE POLICY "Allow public to view files"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'shopimages');