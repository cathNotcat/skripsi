<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class post_user_admin extends Controller
{
    public function getData(Request $request)
    {
        $validated = $request->validate([
            'kode' => 'required|string|max:255',
            'nama' => 'required|string|max:255',
        ]);

        $user = DB::connection('SML')->selectOne(
            'SELECT KodeUser, Username, Nama, Role, IsAktif 
            FROM dbUser 
            WHERE KodeUser COLLATE Latin1_General_CS_AS = ?
            AND Username COLLATE Latin1_General_CS_AS = ?
            ',
            [$validated['kode'], $validated['nama']]
        );

        if (!$user) {
            return response()->json([
                'status' => 404,
                'message' => 'User tidak ada',
            ], 404);
        }

        if ($user->Role !== 'A') {
            return response()->json([
                'status' => 403,
                'message' => "Anda tidak memiliki akses",
            ], 403);
        }

        if ($user->IsAktif != '1') {
            return response()->json([
                'status' => 422,
                'message' => 'Akun tidak ada',
            ], 404);
        }

        return response()->json([
            'status' => 200,
            'message' => 'Data tersedia',
            'data' => [
                'KodeUser' => $user->KodeUser,
                'Username' => $user->Username,
                'Nama' => $user->Nama,
                'Role' => $user->Role,
            ],
        ]);
    }
}