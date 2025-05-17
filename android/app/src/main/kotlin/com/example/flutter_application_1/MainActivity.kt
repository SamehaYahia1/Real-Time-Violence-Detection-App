package com.example.flutter_application_1

import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.*
import java.util.*
import kotlin.concurrent.thread

class MainActivity: FlutterActivity() {
    private val CHANNEL = "onvif_discovery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "discoverOnvifCameras") {
                discoverOnvifCameras(result)
            }
        }
    }

    private fun discoverOnvifCameras(result: MethodChannel.Result) {
        thread {
            try {
                val cameras = mutableListOf<Map<String, String>>()

                val searchMessage = """
                    <?xml version="1.0" encoding="UTF-8"?>
                    <e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"
                                xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"
                                xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"
                                xmlns:dn="http://www.onvif.org/ver10/network/wsdl">
                      <e:Header>
                        <w:MessageID>uuid:${UUID.randomUUID()}</w:MessageID>
                        <w:To>urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>
                        <w:Action>http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe</w:Action>
                      </e:Header>
                      <e:Body>
                        <d:Probe>
                          <d:Types>dn:NetworkVideoTransmitter</d:Types>
                        </d:Probe>
                      </e:Body>
                    </e:Envelope>
                """.trimIndent()

                val group = InetAddress.getByName("239.255.255.250")
                val port = 3702
                val socket = DatagramSocket()
                socket.broadcast = true

                val sendData = searchMessage.toByteArray()
                val packet = DatagramPacket(sendData, sendData.size, group, port)
                socket.send(packet)

                socket.soTimeout = 5000 // 5 seconds

                val buffer = ByteArray(4096)
                val receivePacket = DatagramPacket(buffer, buffer.size)

                val discoveredIPs = mutableSetOf<String>()
                val startTime = System.currentTimeMillis()

                while (System.currentTimeMillis() - startTime < 5000) {
                    try {
                        socket.receive(receivePacket)
                        val data = String(receivePacket.data, 0, receivePacket.length)

                        val ip = receivePacket.address.hostAddress ?: continue
                        if (discoveredIPs.contains(ip)) continue

                        val xaddrRegex = "<.*?XAddrs>(.*?)</.*?XAddrs>".toRegex()
                        val matchResult = xaddrRegex.find(data)
                        val xaddr = matchResult?.groups?.get(1)?.value ?: continue

                        discoveredIPs.add(ip)
                        Log.d("ONVIF_DISCOVERY", "Found camera: $ip")

                        val camera = mapOf("ip" to ip, "xaddrs" to xaddr)
                        cameras.add(camera)

                    } catch (e: Exception) {
                        // Timeout or invalid packet
                    }
                }

                socket.close()

                runOnUiThread {
                    result.success(cameras)
                }

            } catch (e: Exception) {
                Log.e("ONVIF_DISCOVERY", "Error discovering cameras", e)
                runOnUiThread {
                    result.error("DISCOVERY_ERROR", e.message, null)
                }
            }
        }
    }
}
