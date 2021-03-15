
export GCP_CREDENTIALS=$(cat /home/ask/.secrets/askapps-8714096322c0.json)
export BUCKET=stadler_no_test
mix deps.get
iex -S mix phx.server
