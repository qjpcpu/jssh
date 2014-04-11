class String
    def to_black
        "\033[30m#{self}\033[0m"
    end
    def to_red
        "\033[31m#{self}\033[0m"
    end
    def to_yellow
        "\033[33m#{self}\033[0m"
    end
    def to_blue
        "\033[34m#{self}\033[0m"
    end
    def to_white
        "\033[37m#{self}\033[0m"
    end
    def to_green
        "\033[32m#{self}\033[0m"
    end
    def to_cyan
        "\033[36m#{self}\033[0m"
    end
end
