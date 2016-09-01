require 'rest-client'

task :danbooru_new_arrivals => :environment do
    response = RestClient.get 'https://danbooru.donmai.us/posts.json', {:params => {:limit => 1, :page => 1}}
    json = JSON.parse(response)[0]
    url = 'http://danbooru.donmai.us' + json['large_file_url']
    preview_url = 'http://danbooru.donmai.us' + json['preview_file_url']
    puts "#{Time.now} - #{json['id']} / #{url}"

    fcm_response = RestClient::Request.execute(
        method: :post,
        url: 'https://fcm.googleapis.com/fcm/send',
        headers: {
            'Authorization': 'key=' + ENV['KEY'],
            content_type: 'application/json',
        },
        payload: '{"to":"/topics/danbooru_new_arrival", "priority": "high", "notification":{"body": "danbooruの新着画像をお知らせします", "id":"' + json['id'].to_s + '", "image_width":"' + json['image_width'].to_s + '", "image_height":"' + json['image_height'].to_s + '", "preview_file_url":"' + preview_url + '", "large_file_url":"' + url + '", "badge": "1"}}"'
    )


    puts fcm_response
end
