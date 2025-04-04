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
            $tanggalKirim = date('Y-m-d', strtotime($request->input('TanggalKirim')));

            // cari NoPengiriman yang existing di tanggal ini
            $existingNoPengiriman = DB::connection('SML')
                ->table('dbPengiriman')
                ->whereDate('TanggalKirim', $tanggalKirim)
                ->value('NoPengiriman');

            // kalo sdh exist, pakai yang exist aja
            if ($existingNoPengiriman) {
                $newNoPengiriman = $existingNoPengiriman;
            } else {
                $latestNoPengiriman = DB::connection('SML')
                    ->table('dbPengiriman')
                    ->orderBy('NoPengiriman', 'desc')
                    ->value('NoPengiriman');
                $newNoPengiriman = $latestNoPengiriman ? (int) $latestNoPengiriman + 1 : 1;
            }

            $latestNoUrut = DB::connection('SML')
                ->table('dbPengiriman')
                ->where('NoPengiriman', $newNoPengiriman)
                ->max('NoUrut');

            $newNoUrut = $latestNoUrut ? $latestNoUrut + 1 : 1;

            // Prepare the data for insertion
            $data = [
                'NoPengiriman' => $newNoPengiriman,
                'NoUrut' => $newNoUrut,
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
