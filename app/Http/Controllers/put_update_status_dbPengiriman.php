<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class put_update_status_dbPengiriman extends Controller
{
    public function updateStatus(Request $request, $NoPengiriman, $NoUrut)
    {
        $request->validate([
            'Status' => 'required|integer',
            'Latitude' => 'required|numeric',
            'Longitude' => 'required|numeric'
        ]);

        try {
            // Get the current record
            $record = DB::connection('SML')
                ->table('dbPengiriman')
                ->where('NoPengiriman', $NoPengiriman)
                ->where('NoUrut', $NoUrut)
                ->first();

            if (!$record) {
                return response()->json([
                    'status' => 404,
                    'message' => 'Tidak ada data',
                ], 404);
            }

            $newStatus = $request->input('Status');
            $updateData = ['Status' => $newStatus];


            if ((int) $record->Status === 0 && (int) $newStatus === 1) {
                $updateData['MulaiAt'] = Carbon::now()->format('Y-m-d H:i:s') . '.000';
            }

            if ((int) $record->Status === 1 && (int) $newStatus === 2) {
                $updateData['SelesaiAt'] = Carbon::now()->format('Y-m-d H:i:s') . '.000';
                if ($request->has('Latitude') && $request->has('Longitude')) {
                    $updateData['Latitude'] = $request->input('Latitude');
                    $updateData['Longitude'] = $request->input('Longitude');
                }
            }

            // Perform the update
            $affected = DB::connection('SML')
                ->table('dbPengiriman')
                ->where('NoPengiriman', $NoPengiriman)
                ->where('NoUrut', $NoUrut)
                ->update($updateData);

            return response()->json([
                'status' => 200,
                'message' => 'Status berhasil diubah',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'message' => 'Gagal untuk update status',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}

