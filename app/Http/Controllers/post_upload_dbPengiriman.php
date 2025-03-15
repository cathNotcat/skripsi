<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class post_upload_dbPengiriman extends Controller
{
    public function uploadDataPengiriman(Request $request)
    {
        $request->validate([
            'NoDO' => 'required|string|max:255',
            'KodeSopir' => 'required|string|max:255',
            'KodeCustSupp' => 'required|string|max:255',
            'TanggalKirim' => 'required|date_format:Y-m-d H:i:s',
            'Status' => 'required|integer',
        ]);

        try {
            // Fetch the latest NoPengiriman from the database
            $latestPengiriman = DB::connection('SML')
                ->table('dbPengiriman')
                ->orderBy('NoPengiriman', 'desc')
                ->value('NoPengiriman');

            // Increment NoPengiriman
            if ($latestPengiriman) {
                $newNoPengiriman = (int) $latestPengiriman + 1;
            } else {
                $newNoPengiriman = 1;
            }

            // Prepare the data for insertion
            $data = [
                'NoPengiriman' => $newNoPengiriman,
                'NoDO' => $request->input('NoDO'),
                'KodeSopir' => $request->input('KodeSopir'),
                'KodeCustSupp' => $request->input('KodeCustSupp'),
                'TanggalKirim' => $request->input('TanggalKirim'),
                'Status' => $request->input('Status')
            ];

            // Insert the data into the database
            DB::connection('SML')->table('dbPengiriman')->insert($data);

            return response()->json([
                'status' => 200,
                'message' => 'Data berhasil diinsert',
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 500,
                'message' => 'Gagal insert data',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
