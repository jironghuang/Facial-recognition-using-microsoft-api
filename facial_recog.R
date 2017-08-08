# install.packages("httr")
library(httr)

setwd("E:/")
img_links = read.csv("161130_Image Links from TY.csv")
img_links$Image = as.character(img_links$Image)
img_links$clean_link = as.character(img_links$clean_link)


setwd("E:/images")
testit <- function(x){
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1 # The cpu usage should be negligible
}

# Below is the URL having returnFaceLandmarks = true and returnFaceAttributes = age,gender,headPose,smile,facialHair,glasses

face_api_url = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceLandmarks=true&returnFaceAttributes=age,gender,headPose,smile,facialHair,glasses"

Output_Face_Attributes = read.csv("E:/ages.csv")

for(i in 1488:nrow(img_links)){
# for(i in 1:nrow(img_links)){
  print(i)
  link = img_links$clean_link[i]
  if((link!= "") & (i!= 2737) & (i!=4923)){
    # Below is the image we are going to upload
    img_name = i
    body_image = upload_file(paste(img_name,".jpg",sep=""))
    
    # Below is the POST methord (Adding Request headers using add_headers)
    
    result = POST(face_api_url,
                  body = body_image,
                  add_headers(.headers = c("Content-Type"="application/octet-stream",
                                           "Ocp-Apim-Subscription-Key"="XXXXXXXXXXXXXXXXXXX")))
    
    API_Output = content(result)
    
    # Coverting Output into R Dataframe
    Output_Face_Attributes_ind = as.data.frame(API_Output)
      if((nrow(Output_Face_Attributes_ind) != 0) & (ncol(Output_Face_Attributes_ind) == 69)){
        Output_Face_Attributes_ind$id = i
        Output_Face_Attributes = rbind(Output_Face_Attributes_ind,Output_Face_Attributes)
      }
  }else{}
  testit(3.5)
}





