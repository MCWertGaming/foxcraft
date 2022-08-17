#pragma once
#include <string>
#include <curl/curl.h>
#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

struct Credentials {
    std::string access_token;
    std::string user_name;
    std::string user_id;
};
Credentials get_credentials(std::string user, std::string pass)
{
    rapidjson::StringBuffer sb;
    rapidjson::Writer<rapidjson::StringBuffer> writer(sb);

    // write json for post
    writer.StartObject();
    writer.String("agent");
    writer.StartObject();
    writer.String("name");
    writer.String("Minecraft");
    writer.String("version");
    writer.Int(1);
    writer.EndObject();
    writer.String("username");
    writer.String(user.c_str());
    writer.String("password");
    writer.String(pass.c_str());
    // TODO: add client token
    // TODO: user object required?
    writer.EndObject();

    std::string response;

    // send json to server
    CURL *curl = curl_easy_init();
    if(curl) {
        struct curl_slist* headers = nullptr;
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_URL, "https://authserver.mojang.com/authenticate");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, sb.GetString());
        // curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, );
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        if (!curl_easy_perform(curl))
            throw std::runtime_error("curl error on login");
    }
    return {"test"};
}
