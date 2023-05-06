<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\History;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;

class HistoryController extends Controller
{

    public function destroy(History $history) {
        try {
            $histories = $history->delete();

            return ResponseFormatter::success([
                'data' => $histories,
            ], 'Update Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Update Data Failed', 500);
        }
    }

    public function update(History $history, Request $request) {
        try {
            $histories = $history->update($request->all());

            return ResponseFormatter::success([
                'data' => $histories,
            ], 'Update Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Update Data Failed', 500);
        }
    }

    public function show(Request $request) {
        try {
            if($request->date && $request->type && $request->id) {
                $histories = History::where(['user_id' => $request->user_id, 'type' => $request->type, 'date' => $request->date])->get();
            } elseif ($request->user_id && $request->id) {
                $histories = History::where('id', $request->id)->first();
            }elseif($request->user_id && $request->type) {
                $histories = History::where(['user_id' => $request->user_id, 'type' => $request->type])->get();
            } elseif ($request->user_id && $request->date) {
                $histories = History::where(['user_id' => $request->user_id, 'date' => $request->date])->get();
            }else {
                $histories = History::where('user_id', $request->user_id)->get();
            }

            return ResponseFormatter::success([
                'data' => $histories,
            ], 'Get Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Get Data Failed', 500);
        }

    }

    public function store(Request $request) 
    {
        date_default_timezone_set('Asia/Jakarta');
        try{
            $validatedData = $request->validate([
                "user_id" => ['required'],
                "type" => ['required', 'string'],
                "date" => ['required', 'string'],
                "total" => ['required', 'string'],
                "details" => ['required', 'string'],
            ]);

            $data = History::create($validatedData);
            
            return ResponseFormatter::success([
                'data' => $data
            ], 'Create Data Success.');

        } catch(Exception $e) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong.',
                'error' => $e,
            ], 'Create Data Failed', 500);
        }
    }
}
