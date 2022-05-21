import Shell

main ∷ IO ()
main = do
    ls
    cat "/etc/passwd"
