<?php

namespace App\Http\Controllers;

use App\Services\FirebaseService;
use Illuminate\Http\Request;

class post_notification extends Controller
{
    protected $firebaseService;

    // Inject the FirebaseService into the controller
    public function __construct(FirebaseService $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    // API endpoint to send a notification
    public function sendNotification(Request $request)
    {
        // Validate incoming request parameters
        $validated = $request->validate([
            'device_token' => 'required|string',
            'title' => 'required|string',
            'body' => 'required|string',
        ]);

        // Get the validated data
        $deviceToken = $validated['device_token'];
        $title = $validated['title'];
        $body = $validated['body'];

        // Call the Firebase service to send the notification
        return $this->firebaseService->sendNotification($deviceToken, $title, $body);
    }
}
