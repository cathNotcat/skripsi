<?php
namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FirebaseService
{
    protected $messaging;

    public function __construct()
    {
        // Initialize Firebase with your service account key
        $firebase = (new Factory)->withServiceAccount(storage_path('app\firebase\atomic-drake-429902-a7-18cfb-8eecf0c48d7f.json'));
        $this->messaging = $firebase->createMessaging();
    }

    // Send notification to the device with the given token
    public function sendNotification($deviceToken, $title, $body)
    {
        // Create the notification message
        $notification = Notification::create($title, $body);
        $message = CloudMessage::withTarget('token', $deviceToken)
            ->withNotification($notification);

        // Send the message to FCM
        try {
            $this->messaging->send($message);
            return response()->json(['message' => 'Notification sent successfully']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()]);
        }
    }
}

// namespace App\Services;

// use Kreait\Firebase\Factory;
// use Kreait\Firebase\Messaging\CloudMessage;
// use Kreait\Firebase\Messaging\Notification;

// class FirebaseService
// {
//     protected $messaging;



//     public function __construct()
//     {
//         // Initialize Firebase with your service account key
//         $firebase = (new Factory)->withServiceAccount(storage_path('app\firebase\atomic-drake-429902-a7-18cfb-8eecf0c48d7f.json'));
//         $this->messaging = $firebase->createMessaging();
//     }

//     // Send notification to the device with the given token
//     public function sendNotification($deviceToken, $title, $body)
//     {
//         // FCM URL for sending notifications
//         $url = 'https://fcm.googleapis.com/fcm/send';

//         // Prepare the notification payload
//         $fields = [
//             'to' => $deviceToken,
//             'notification' => [
//                 'title' => $title,
//                 'body' => $body,
//             ],
//         ];

//         // Prepare the headers with the Firebase Server Key
//         $headers = [
//             'Authorization: key=YOUR_SERVER_KEY', // Replace with your actual Firebase server key
//             'Content-Type: application/json',
//         ];

//         // Initialize cURL session
//         $ch = curl_init();
//         curl_setopt($ch, CURLOPT_URL, $url);
//         curl_setopt($ch, CURLOPT_POST, true);
//         curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
//         curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//         curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

//         // Execute the request
//         $result = curl_exec($ch);

//         // Check if any error occurred during the request
//         if (curl_errno($ch)) {
//             return response()->json(['error' => curl_error($ch)], 500);
//         }

//         // Close cURL session
//         curl_close($ch);

//         // Return success response
//         return response()->json(['message' => 'Notification sent successfully', 'result' => $result]);
//     }



// }
