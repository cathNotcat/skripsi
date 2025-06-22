<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\Client;

class get_distance extends Controller
{
    public function getRoute(Request $request)
    {
        $start = $request->query('start');
        $end = $request->query('end');

        $client = new Client();
        $apiKey = env('OPENROUTESERVICE_API_KEY');

        $response = $client->get('https://api.openrouteservice.org/v2/directions/driving-car', [
            'query' => [
                'api_key' => '5b3ce3597851110001cf6248ca8bbc2113444302abccf5e8fcd0032f',
                'start' => $start,
                'end' => $end,
            ],
        ]);

        return response()->json(json_decode($response->getBody(), true));
    }
}
