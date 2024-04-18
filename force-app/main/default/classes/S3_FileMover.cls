public class S3_FileMover {
    public static void moveFile(String folderName, String fileName) {
        String bucketName = 'tmktestbucket-dec23';
        String originalFilePath = folderName + '/' + fileName;
        String destinationFolderPath = folderName + '/Archived/';
        String destinationFilePath = destinationFolderPath + fileName;
        String namedCredentialName = Label.S3_Bucket; // Replace with your named credential name

        // Copy the file to the new location
        if (copyS3File(bucketName, originalFilePath, destinationFilePath, namedCredentialName)) {
            // Delete the original file if the copy was successful
            if (!deleteS3File(bucketName, originalFilePath, namedCredentialName)) {
                System.debug('Error deleting original file.');
            }
        } else {
            System.debug('Error copying file.');
        }
    }

    private static boolean copyS3File(String bucketName, String originalFilePath, String destinationFilePath, String namedCredentialName) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:' + namedCredentialName + '/' + destinationFilePath);
        request.setMethod('PUT');
        request.setHeader('x-amz-copy-source', '/' + bucketName + '/' + originalFilePath);
        HttpResponse response = http.send(request);
        return response.getStatusCode() == 200;
    }

    private static boolean deleteS3File(String bucketName, String filePath, String namedCredentialName) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:' + namedCredentialName + '/' + filePath);
        request.setMethod('DELETE');
        HttpResponse response = http.send(request);
        return response.getStatusCode() == 200;
    }
}