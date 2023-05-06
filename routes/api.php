<?php

use App\Http\Controllers\Api\AnalysisController;
use App\Http\Controllers\Api\HistoryController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// AUTHENTICATION
Route::post("register", [UserController::class, 'register']);
Route::post("login", [UserController::class, 'login']);


// ANALYSIS
Route::post("analytics", [AnalysisController::class, 'analytics']);

// HISTORIES
Route::delete("history/{history}", [HistoryController::class, 'destroy']);
Route::put("history/{history}", [HistoryController::class, 'update']);
Route::post("history/show", [HistoryController::class, 'show']);
Route::post("history", [HistoryController::class, 'store']);