<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class put_update_status_dbPengiriman extends Controller
{
    public function updateStatus(Request $request, $NoPengiriman, $NoUrut)
    {
        $request->validate([
            'Status' => 'required|integer',
        ]);

        try {
            // Find the record in the database by NoPengiriman
            $affected = DB::connection('SML')
                ->table('dbPengiriman')
                ->where('NoPengiriman', $NoPengiriman)
                ->where('NoUrut', $NoUrut)
                ->update(['Status' => $request->input('Status')]);

            // Check if any rows were affected
            if ($affected) {
                return response()->json([
                    'status' => 200,
                    'message' => 'Status updated successfully',
                ]);
            } else {
                return response()->json([
                    'status' => 404,
                    'message' => 'No data found with the provided NoPengiriman',
                ], 404);
            }
        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'message' => 'Failed to update status',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}