xml.instruct!
xml.env(:Envelope, "xmlns:env" => "http://www.w3.org/2003/05/soap-envelope", "xmlns:replay" => "http://www.leandog.com/replay") do
  xml.env :Body do
    xml.replay(:StoreResponse, 'Success')
  end
end
