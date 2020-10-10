library(gmailr)


gm_auth_configure(path = "C:/Users/ronal/Documents/credentials_gmail.json")


#gm_auth()


gm_auth(email = TRUE, cache = "C:/Users/ronal/.R/gargle/gargle-oauth")


test_email <-
  gm_mime() %>%
  gm_to("xxx@xxx.com.pe") %>%
  gm_from("xxxx@gmail.com") %>%
  gm_subject("hola desde local y automatico") %>%
  gm_text_body("Can you hear me now?")

gm_send_message(test_email)
